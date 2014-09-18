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
#import "JMAnimatedImageView+Image.h"
#import "JMAnimatedLog.h"

typedef NS_ENUM(NSUInteger, UIImageViewAnimationOption) {
    UIImageViewAnimationOptionLinear = 0,
    UIImageViewAnimationOptionCurveEaseInOut
};

typedef NS_ENUM(NSUInteger, UIImageViewAnimationState) {
    UIImageViewAnimationStateStopped = 0,
    UIImageViewAnimationStateInPgrogress
};

@interface JMAnimatedImageView()
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger operationInQueue;
@property (nonatomic, strong) NSOperationQueue *animationQueue;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) dispatch_queue_t animationManagementQueue;
@property (assign, nonatomic) UIImageViewAnimationState animationState;

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
    _animationType = JMAnimatedImageViewAnimationTypeInteractive;
    _animationQueue = [NSOperationQueue new];
    _animationQueue.name = @"JMAnimatedImageViewAnimationQueue";
    _animationQueue.maxConcurrentOperationCount = 1;
    _animationManagementQueue = dispatch_queue_create("com.animationManagement.queue", NULL);
    _imageOrder = JMAnimatedImageViewOrderNormal;
    [self setInteractiveAnimation:NO];
    self.clipsToBounds = YES;
}

- (void)reloadAnimationImages
{
    if ([self.animationDatasource respondsToSelector:@selector(firstIndexForAnimatedImageView:)]) {
        [self setCurrentCardImageAtindex:[self.animationDatasource firstIndexForAnimatedImageView:self]];
    } else {
        [self setCurrentCardImageAtindex:0];
    }
}

- (void)reloadAnimationImagesFromGifData:(NSData *)data
{
    _gifObject = [[JMGif alloc] initWithData:data];
    self.animationDuration = JMDefaultGifDuration;
    [self setCurrentCardImageAtindex:0];
}

- (void)reloadAnimationImagesFromGifNamed:(NSString *)gitName
{
    _gifObject = [JMGif gifNamed:gitName];
    self.animationDuration = JMDefaultGifDuration;
    [self setCurrentCardImageAtindex:0];
    [self updateGestures];
}

- (BOOL)checkLifeCycleSanity
{
    if (self.superview) {
        return YES;
    }
    
    return NO;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    if ([self.animationDelegate respondsToSelector:@selector(imageView:didChangeCurrentindex:)]) {
        [self.animationDelegate imageView:self didChangeCurrentindex:_currentIndex];
    }
}

- (void)setupTempImageViewAtOriginiX:(CGFloat)x
{
    [self.tempSwapedImageView removeFromSuperview];
    self.tempSwapedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
    CGRect frame = self.tempSwapedImageView.frame;
    frame.origin.x = x;
    self.tempSwapedImageView.frame = frame;
    
    self.tempSwapedImageView.contentMode = self.contentMode;
    
    //add shadow
    self.tempSwapedImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.tempSwapedImageView.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
    self.tempSwapedImageView.layer.shadowOpacity = 0.7f;
    self.tempSwapedImageView.layer.shadowRadius = 10.0f;
    CGRect shadowRect = CGRectInset(self.tempSwapedImageView.bounds, 0, 4);  // inset top/bottom
    self.tempSwapedImageView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:shadowRect] CGPath];
    [self addSubview:self.tempSwapedImageView];
    
    if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
        [self bringSubviewToFront:self.pageControl];
    }
}

#pragma mark - overided setter

- (BOOL)isAGifImageView
{
    if (_gifObject) {
        return YES;
    }
    return NO;
}

- (void)setInteractiveAnimation:(BOOL)interactiveAnimation
{
    _interactiveAnimation = interactiveAnimation;
    [self updateGestures];
}

- (void)setAnimationType:(JMAnimatedImageViewAnimationType)animationType
{
    _animationType = animationType;
    if (animationType == JMAnimatedImageViewAnimationTypeInteractive) {
        [self setInteractiveAnimation:YES];
    }
}

- (UIPageControl *)pageControl
{
    if (nil == _pageControl) {
        //Max size 30% of the width
        CGRect pageControlFrame = CGRectMake(
                                             floorf(0.5 * (CGRectGetWidth(self.frame) - (CGRectGetWidth(self.frame) * 0.3))),
                                             CGRectGetHeight(self.frame) - 30.0f,
                                             floorf(CGRectGetWidth(self.frame) * 0.3),
                                             30.0f);
        _pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
        _pageControl.numberOfPages = [self numberOfImages];
        _pageControl.currentPage = 0;
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

#pragma mark - Gesture management

- (void)updateGestures
{
    if (self.interactiveAnimation == YES) {
        if (nil == self.panGesture) {
            self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouched:)];
            [self addGestureRecognizer:self.panGesture];
        }
        if (nil == self.tapGesture) {
            self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouched:)];
            [self addGestureRecognizer:self.tapGesture];
        }
    } else {
        if (nil != self.panGesture) {
            [self removeGestureRecognizer:self.panGesture];
            self.panGesture = nil;
        }
        if (nil != self.tapGesture) {
            [self removeGestureRecognizer:self.tapGesture];
            self.tapGesture = nil;
        }
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
        UIImage *img = 0;
        if(velocity.x > 0) {
            img = [self imageAtIndex:[self realIndexForComputedIndex:self.currentIndex+1]];
            [self setupTempImageViewAtOriginiX:-CGRectGetWidth(self.bounds)];
            
        } else {
            img = [self imageAtIndex:[self realIndexForComputedIndex:self.currentIndex-1]];
            [self setupTempImageViewAtOriginiX:CGRectGetWidth(self.bounds)];
        }
        
        self.tempSwapedImageView.image = img;
        
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
        BOOL finishSwipeEvent = NO;
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
                    [self setCurrentCardImageAtindex:[self realIndexForComputedIndex:self.currentIndex + 1]];
                } else {
                    [self setCurrentCardImageAtindex:[self realIndexForComputedIndex:self.currentIndex -1 ]];
                }
            }
        }];
    }
}

- (void)imageViewTouchedWithPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
        [self imageViewTouchedWithFollowingPanGesture:gestureRecognizer];
        return;
        
    } else if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition) {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            [self startAnimating];
            return;
        }
    }
    
    [self cancelAnimations];
    [self stopAnimating];
    
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    NSInteger index = [self currentIndex];
    
    //compute point unity
    NSInteger pointUnity = self.frame.size.width / [self numberOfImages];
    
    //Compute inerty using velocity
    NSInteger shift = abs(velocity.x) / (16 * [UIScreen mainScreen].scale * pointUnity);
    
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
    NSInteger realIndex = [self realIndexForComputedIndex:index];
    self.image = [self imageAtIndex:realIndex];
    self.currentIndex = realIndex;
    
    if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
        [self updatePageControl];
    }
}

- (void)setCurrentImage:(UIImage *)img forIndex:(NSInteger)index
{
    JMLog(@"%s index:%d",__FUNCTION__,(int)index);
    NSInteger realIndex = [self realIndexForComputedIndex:index];
    self.image = img;
    self.currentIndex = realIndex;
    if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
        [self updatePageControl];
    }
}

- (NSInteger)realIndexForComputedIndex:(NSInteger)index
{
    NSInteger nb = [self numberOfImages];
    
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

- (void)moveCurrentCardImageFromIndex:(NSInteger)fromIndex
                                shift:(NSInteger)shift
                         withDuration:(NSTimeInterval)duration
                      animationOption:(UIImageViewAnimationOption)option
                  withCompletionBlock:(JMCompletionFinishBlock)finishBlock
{
    dispatch_async(self.animationManagementQueue, ^{
        NSTimeInterval unitDuration;
        NSInteger shiftUnit = shift / abs(shift); // 1 ou -1
        
        if (duration == JMDefaultGifDuration) {
            unitDuration = duration;

        } else {
            if (option == UIImageViewAnimationOptionLinear) {
                unitDuration = duration / abs(shift);
            } else {
                unitDuration = duration / abs(shift * shift);
            }
        }
        
        JMLog(@"%s fromIndex:%d shift:%d duration:%lf",__FUNCTION__,(int)fromIndex,(int)shift,duration);
        
        //[self cancelAnimations];
        [self.animationQueue cancelAllOperations];
        [self.animationQueue waitUntilAllOperationsAreFinished];
        
        //Compute minimal interval to perform an image switch 30hz ..
        NSTimeInterval minimumInterval = 1.0/30.0;
        NSTimeInterval currentInterval = 0.0;
        
        for (int i = 0; i < (int)abs((int)shift) ; i++) {
                
            currentInterval = currentInterval + unitDuration;
            if(((currentInterval < minimumInterval) && [self isAGifImageView] == NO)) {
                continue;
                
            } else {
                NSInteger index = [self realIndexForComputedIndex:fromIndex+i*shiftUnit];

                if ([self isAGifImageView]) {
                    JMGifItem *item = [[self.gifObject items] objectAtIndex:index];
                    NSNumber *delay = [item.delay objectForKey:JMGifItemDelayTimeKey];
                    currentInterval = [delay doubleValue];
                }
                
                JMAnimationOperation *operation = [JMAnimationOperation animationOperationWithDuration:currentInterval
                                                                                            completion:^(BOOL finished)
                {

                    if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition) {
                        if ([self operationQueueIsFinished] == YES) {
                            if (finishBlock) {
                                finishBlock(YES);
                            }
                            
                            if (self.animationRepeatCount == 0 && self.animationState == UIImageViewAnimationStateInPgrogress) {
                               [self continueAnimating];
                            }
                        }
                    }
                }];
                
                operation.animatedImageView = self;
                operation.imageIndex = index;
                
                currentInterval = 0;
                [self.animationQueue addOperation:operation];
            }
        }
    });
}

- (void)changeImageToIndex:(NSInteger)index withTimeInterval:(NSTimeInterval)duration repeat:(BOOL)repeat
{
    if ([self checkLifeCycleSanity] == NO) {
        return;
    }
    
    if (duration == -1) {
        [self setCurrentIndex:index];
    }
    
    //animation changement
    [self setupTempImageViewAtOriginiX:CGRectGetWidth(self.bounds)];
    
    self.tempSwapedImageView.image = [self imageAtIndex:[self realIndexForComputedIndex:index] ];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.tempSwapedImageView.frame;
        frame.origin.x = 0.0f;
        self.tempSwapedImageView.frame = frame;
        
    } completion:^(BOOL finished) {
        [self.tempSwapedImageView removeFromSuperview];
        [self setCurrentCardImageAtindex:[self realIndexForComputedIndex:index]];
        if (repeat) {
            [self changeImageToIndex:(self.currentIndex+1) withTimeInterval:duration repeat:repeat];
        }
    }];
}

#pragma mark - Manage images automatic animation

- (void)animateToIndex:(NSInteger)index withDuration:(NSTimeInterval)duration withCompletionBlock:(JMCompletionFinishBlock)finishBlock
{
    [self stopAnimating];
    
    //find minimum shift
    [self moveCurrentCardImageFromIndex:self.currentIndex
                                  shift:[self minimalShiftFromIndex:self.currentIndex toIndex:index]
                           withDuration:duration
                        animationOption:UIImageViewAnimationOptionLinear
                    withCompletionBlock:finishBlock];
}


- (void)animateToIndex:(NSInteger)index withDuration:(NSTimeInterval)duration
{
    [self animateToIndex:index withDuration:duration withCompletionBlock:NULL];
}

- (NSInteger)minimalShiftFromIndex:(NSInteger)index toIndex:(NSInteger)toIndex
{
    //compute decrement
    NSInteger nbDecrement = 0;
    if (toIndex < index) {
        nbDecrement = index - toIndex;
    } else {
        nbDecrement = index + toIndex;
    }
    
    //compute increment
    NSInteger nbIncrement = 0;
    if (index < toIndex) {
        nbIncrement = toIndex - index;
    } else {
        nbIncrement = ([self.animationDatasource numberOfImagesForAnimatedImageView:self] - index) + toIndex;
    }
    
    if (nbIncrement < nbDecrement) {
        return nbIncrement;
    }
    return -nbDecrement;
}


- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated
{
    if (animated) {
        [self changeImageToIndex:index withTimeInterval:0.25 repeat:NO];
    } else {
        [self changeImageToIndex:index withTimeInterval:-1 repeat:NO];
    }
}

- (void)setImage:(UIImage *)img forCurrentIndex:(NSInteger)index
{
    NSInteger realIndex = [self realIndexForComputedIndex:index];
//    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = img;
        self.currentIndex = realIndex;
//    });
}

- (void)startAnimating
{
    self.animationState = UIImageViewAnimationStateInPgrogress;

    if ([self checkLifeCycleSanity] == NO) {
        return;
    }
    
    if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition) {
        if ([self isAGifImageView]) {
            [self moveCurrentCardImageFromIndex:self.currentIndex
                                          shift:_gifObject.items.count
                                   withDuration:self.animationDuration
                                animationOption:UIImageViewAnimationOptionLinear
                            withCompletionBlock:NULL];
        } else {
            [self moveCurrentCardImageFromIndex:self.currentIndex
                                          shift:[self numberOfImages]
                                   withDuration:self.animationDuration
                                animationOption:UIImageViewAnimationOptionLinear
                            withCompletionBlock:NULL];
        }

    } else if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinear) {
        [self changeImageToIndex:(self.currentIndex + 1) withTimeInterval:self.animationDuration repeat:YES];
    }
}

- (void)continueAnimating
{
    self.animationState = UIImageViewAnimationStateInPgrogress;

    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self checkLifeCycleSanity] == NO) {
            return;
        }
        
        if ([self operationQueueIsFinished] == NO) {
            return;
        }
        
        if ([self isAGifImageView]) {
            [self moveCurrentCardImageFromIndex:self.currentIndex
                                          shift:self.gifObject.items.count
                                   withDuration:self.animationDuration
                                animationOption:UIImageViewAnimationOptionLinear
                            withCompletionBlock:NULL];
        } else {
            [self moveCurrentCardImageFromIndex:self.currentIndex
                                          shift:[self numberOfImages]
                                   withDuration:self.animationDuration
                                animationOption:UIImageViewAnimationOptionLinear
                            withCompletionBlock:NULL];
        }
    });
}

- (void)stopAnimating
{
    self.animationState = UIImageViewAnimationStateStopped;
    [self cancelAnimations];
}

- (BOOL)isAnimating
{
    return NO;
}

- (BOOL)operationQueueIsFinished
{
    NSArray *opeInProgress = [self.animationQueue valueForKeyPath:@"operations"];
    if (opeInProgress.count == 0) {
        return YES;
    }
    return NO;
}

- (void)cancelAnimations
{
    //NSLog(@"Cancel %d operations ", (int)[[self.animationQueue operations] count]);
    for (NSOperation* o in [self.animationQueue operations]) {
        if ([o isKindOfClass:[o class]]) {
            [o cancel];
        }
    }
}

@end
