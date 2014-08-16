//
//  JMAnimatedImageView.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimatedImageView.h"
#import "JMAnimationOperation.h"
#import "UIImage+JM.h"

typedef NS_ENUM(NSUInteger, UIImageViewAnimationOption) {
    UIImageViewAnimationOptionLinear = 0,
    UIImageViewAnimationOptionCurveEaseInOut
};

@interface JMAnimatedImageView()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger operationInQueue;
@property (nonatomic, strong) NSOperationQueue *animationQueue;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) dispatch_queue_t animationManagementQueue;

//Specific to animation type JMAnimatedImageViewAnimationTypeManualSwipe
@property (nonatomic, strong) UIImageView *tempSwapedImageView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation JMAnimatedImageView

#pragma mark - init 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.userInteractionEnabled = YES;
    _memoryManagementOption = JMAnimatedImageViewMemoryLoadImageSystemCache;
    _animationType = JMAnimatedImageViewAnimationTypeManualRealTime;
    _animationQueue = [NSOperationQueue new];
    _animationQueue.maxConcurrentOperationCount = 1;
    _animationManagementQueue = dispatch_queue_create("com.animationManagement.queue", NULL);
    _imageOrder = JMAnimatedImageViewOrderNormal;
    self.clipsToBounds = YES;
}

- (void)reloadAnimationImages
{
    //Load the 1st
    [self setCurrentCardImageAtindex:0];
    [self addGesturesForAnimationType:_animationType];
}

#pragma mark - overided setter

- (void)setAnimationType:(JMAnimatedImageViewAnimationType)animationType
{
    _animationType = animationType;
    [self addGesturesForAnimationType:animationType];
}

#pragma mark - Gesture management

- (void)addGesturesForAnimationType:(JMAnimatedImageViewAnimationType)animationType
{
    switch (animationType) {
        case JMAnimatedImageViewAnimationTypeManualSwipe:
            if (nil == self.panGesture) {
                self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouched:)];
                [self addGestureRecognizer:self.panGesture];
            }
            if (nil == self.pageControl) {
                //Max size 30% of the width
                CGRect pageControlFrame = CGRectMake(
                                                     0.5 * (CGRectGetWidth(self.frame) - (CGRectGetWidth(self.frame) * 0.3)),
                                                     CGRectGetHeight(self.frame) - 30.0f,
                                                     CGRectGetWidth(self.frame) * 0.3,
                                                     30.0f);
                self.pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
                self.pageControl.numberOfPages = [self.animationDatasource numberOfImagesForAnimatedImageView:self];
                self.pageControl.currentPage = 0;
                [self addSubview:self.pageControl];
            }
            break;
          
        case JMAnimatedImageViewAnimationTypeManualRealTime:
            if (nil == self.panGesture) {
                self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouched:)];
                [self addGestureRecognizer:self.panGesture];
            }
            
            if (nil == self.tapGesture) {
                self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouched:)];
                [self addGestureRecognizer:self.tapGesture];
            }
            break;
           
        case JMAnimatedImageViewAnimationTypeAutomaticLinear:
            break;
         
        case JMAnimatedImageViewAnimationTypeAutomaticReverse:
            break;
            
        default:
            break;
    }
}

- (void)imageViewTouchedWithTapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    [self cancelAnimations];
}

- (void)imageViewTouchedWithFollowingPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.tempSwapedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImage *img = 0;
        if(velocity.x > 0) {
            NSString *imgName = [self.animationDatasource imageNameAtIndex:[self realIndexForComputedIndex:self.currentIndex+1] forAnimatedImageView:self];
            img = [UIImage jm_imageNamed:imgName];
            CGRect frame = self.tempSwapedImageView.frame;
            frame.origin.x = -CGRectGetWidth(frame);
            self.tempSwapedImageView.frame = frame;
        } else {
            NSString *imgName = [self.animationDatasource imageNameAtIndex:[self realIndexForComputedIndex:self.currentIndex-1] forAnimatedImageView:self];
            img = [UIImage jm_imageNamed:imgName];
            CGRect frame = self.tempSwapedImageView.frame;
            frame.origin.x = CGRectGetWidth(frame);
            self.tempSwapedImageView.frame = frame;
        }
        
        self.tempSwapedImageView.image = img;
        self.tempSwapedImageView.contentMode = self.contentMode;
        
        //add shadow
        self.tempSwapedImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.tempSwapedImageView.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
        self.tempSwapedImageView.layer.shadowOpacity = 0.7f;
        self.tempSwapedImageView.layer.shadowRadius = 10.0f;
        CGRect shadowRect = CGRectInset(self.tempSwapedImageView.bounds, 0, 4);  // inset top/bottom
        self.tempSwapedImageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
        [self addSubview:self.tempSwapedImageView];
        [self bringSubviewToFront:self.pageControl];
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            CGRect frame = self.tempSwapedImageView.frame;
            frame.origin.x = -CGRectGetWidth(frame) + [gestureRecognizer translationInView:self].x;
            self.tempSwapedImageView.frame = frame;
        } else {
            CGRect frame = self.tempSwapedImageView.frame;
            frame.origin.x = CGRectGetWidth(frame) + [gestureRecognizer translationInView:self].x;
            self.tempSwapedImageView.frame = frame;
        }
        
    } else {
        self.userInteractionEnabled = NO;

        //Compute if we need to finish the swip
        CGRect inter =  CGRectIntersection(self.bounds, self.tempSwapedImageView.frame);
        BOOL finishSwipeEvent;
        if ((inter.size.width * inter.size.height) > (0.3 * self.bounds.size.height * self.bounds.size.width)) {
            finishSwipeEvent = YES;
        }

        [UIView animateWithDuration:0.25 animations:^{
            if (finishSwipeEvent) {
                CGRect frame = self.tempSwapedImageView.frame;
                frame.origin.x = 0;
                self.tempSwapedImageView.frame = frame;
            } else {
                if (self.tempSwapedImageView.frame.origin.x > 0) {
                    CGRect frame = self.tempSwapedImageView.frame;
                    frame.origin.x = self.bounds.size.width;
                    self.tempSwapedImageView.frame = frame;
                } else {
                    CGRect frame = self.tempSwapedImageView.frame;
                    frame.origin.x = -self.bounds.size.width;
                    self.tempSwapedImageView.frame = frame;
                }
            }
        } completion:^(BOOL finished) {
            [self.tempSwapedImageView removeFromSuperview];
            self.userInteractionEnabled = YES;
            if (finishSwipeEvent) {
                if (velocity.x > 0) {
                    [self setCurrentCardImageAtindex:[self realIndexForComputedIndex:self.currentIndex+1]];
                } else {
                    [self setCurrentCardImageAtindex:[self realIndexForComputedIndex:self.currentIndex-1]];
                }
            }
        }];
    }
}

- (void)imageViewTouchedWithPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s",__FUNCTION__);
    [self cancelAnimations];
    
    if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
        [self imageViewTouchedWithFollowingPanGesture:gestureRecognizer];
        return;
    }
    
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    NSInteger index = [self currentIndex];
    
    //compute point unity
    NSInteger pointUnity = self.frame.size.width / [self.animationDatasource numberOfImagesForAnimatedImageView:self];
    
    //Compute inerty using velocity
    NSInteger shift = abs(velocity.x) / (8 * [UIScreen mainScreen].scale * pointUnity);
    
    if(velocity.x > 0) {
        [self setCurrentCardImageAtindex:index+(_imageOrder) * shift];
    } else {
        [self setCurrentCardImageAtindex:index-(_imageOrder) * shift];
    }
    
    /*
     if(abs(velocity.x) > 100 && (
     gestureRecognizer.state == UIGestureRecognizerStateEnded ||
     gestureRecognizer.state == UIGestureRecognizerStateCancelled))
     {
     //compute point unity
     NSInteger pointUnity = self.frame.size.width / [self.animationDatasource numberOfImagesForAnimatedImageView:self];
     
     //Compute inerty using velocity
     NSInteger shift = abs(velocity.x) / ([UIScreen mainScreen].scale * pointUnity);
     if(velocity.x > 0) {
     [self moveCurrentCardImageFromIndex:index+1 shift:shift withDuration:3.0];
     NSLog(@"gesture inerty went right");
     } else {
     [self moveCurrentCardImageFromIndex:index-1 shift:-shift withDuration:3.0];
     NSLog(@"gesture inerty went left");
     }
     }
     */
}

- (void)imageViewTouched:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        [self imageViewTouchedWithPanGesture:(UIPanGestureRecognizer*)gestureRecognizer];
    } else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [self imageViewTouchedWithTapGesture:(UITapGestureRecognizer*)gestureRecognizer];
    }
}

#pragma mark - Load images

- (void)setCurrentCardImageAtindex:(NSInteger)index
{
    NSLog(@"%s index:%d",__FUNCTION__,(int)index);
    NSInteger realIndex = [self realIndexForComputedIndex:index];
    
    if (self.memoryManagementOption == JMAnimatedImageViewMemoryLoadImageCustom) {
        if ([self.animationDatasource respondsToSelector:@selector(imageAtIndex:forAnimatedImageView:)]) {
            UIImage *image = [self.animationDatasource imageAtIndex:realIndex forAnimatedImageView:self];
            self.image = image;
        } else {
            NSAssert(0, @"animationDatasource should implement imageAtIndex:forAnimatedImageView: if you use JMAnimatedImageViewMemoryLoadImageCustom");
        }
    } else {
        NSString *imageName = [self.animationDatasource imageNameAtIndex:realIndex forAnimatedImageView:self];
        self.image = [UIImage jm_imageNamed:imageName withOption:self.memoryManagementOption];
    }
    
    self.currentIndex = realIndex;
    [self updatePageControl];
}

- (void)setCurrentImage:(UIImage *)img forIndex:(NSInteger)index
{
    NSLog(@"%s index:%d",__FUNCTION__,(int)index);
    NSInteger realIndex = [self realIndexForComputedIndex:index];
    self.image = img;
    self.currentIndex = realIndex;
    [self updatePageControl];
}

- (NSInteger)realIndexForComputedIndex:(NSInteger)index
{
    NSInteger nb = [self.animationDatasource numberOfImagesForAnimatedImageView:self];
    
    if (index < 0) {
        return nb + index;
    } else if (index >= nb) {
        index = index - nb;
    }
    
    return index;
}

- (void)updatePageControl
{
    self.pageControl.currentPage = self.currentIndex;
}

- (void)moveCurrentCardImageFromIndex:(NSInteger)fromIndex shift:(NSInteger)shift withDuration:(NSTimeInterval)duration animationOption:(UIImageViewAnimationOption)option
{
    dispatch_async(self.animationManagementQueue, ^{
        NSTimeInterval unitDuration = duration;
        if (option == UIImageViewAnimationOptionLinear) {
            unitDuration = duration / shift;
            
        } else {
            unitDuration = duration / (shift * shift);
        }
        
        NSLog(@"%s fromIndex:%d shift:%d duration:%lf",__FUNCTION__,(int)fromIndex,(int)shift,duration);
        
        //[self cancelAnimations];
        [self.animationQueue cancelAllOperations];
        [self.animationQueue waitUntilAllOperationsAreFinished];
        
        NSTimeInterval minimumInterval = 1.0/30.0;
        NSTimeInterval currentInterval = 0.0;
        
        for (int i = 0; i < (int)abs((int)shift) ; i++) {
            currentInterval = currentInterval + unitDuration;
            if (currentInterval < minimumInterval) {
                continue;
            } else {
                
                NSInteger index = [self realIndexForComputedIndex:fromIndex+i];
                JMAnimationOperation *operation = [JMAnimationOperation animationOperationWithDuration:currentInterval animations:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self setCurrentCardImageAtindex:index];
                    });
                } completion:^(BOOL finished) {
                    if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinear && [self operationQueueIsFinished] == YES) {
                        [self continueAnimating];
                    }
                }];

                currentInterval = 0;
                [self.animationQueue addOperation:operation];
            }
        }
    });
}

#pragma mark - Manage images automatic animation

- (void)startAnimating
{
    NSLog(@"%s",__FUNCTION__);
    [self setCurrentCardImageAtindex:0];
    [self moveCurrentCardImageFromIndex:0
                                  shift:[self.animationDatasource
                                         numberOfImagesForAnimatedImageView:self]
                           withDuration:self.animationDuration
                        animationOption:UIImageViewAnimationOptionLinear];
}

- (void)continueAnimating
{
    NSLog(@"%s",__FUNCTION__);
    if ([self operationQueueIsFinished] == NO) {
        return;
    }
    
    [self moveCurrentCardImageFromIndex:0
                                  shift:[self.animationDatasource
                                         numberOfImagesForAnimatedImageView:self]
                           withDuration:self.animationDuration
                        animationOption:UIImageViewAnimationOptionLinear];
}

- (void)stopAnimating
{
    [self cancelAnimations];
}

- (BOOL)isAnimating
{
    return NO;
}

- (BOOL)operationQueueIsFinished
{
    NSArray *opeInProgress = [self.animationQueue valueForKeyPath:@"operations"];
    //NSArray *distinct = [isExecuting valueForKeyPath:@"@distinctUnionOfObjects.self"];
    if (opeInProgress.count == 0) {
        return YES;
    }
    return NO;
}

- (void)cancelAnimations
{
    NSLog(@"Cancel %d operations ", (int)[[self.animationQueue operations] count]);
    for (NSOperation* o in [self.animationQueue operations]) {
        if ([o isKindOfClass:[o class]]) {
            [o cancel];
        }
    }
}

@end
