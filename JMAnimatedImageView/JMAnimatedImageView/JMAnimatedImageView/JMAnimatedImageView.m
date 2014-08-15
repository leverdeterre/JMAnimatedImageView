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
}

#pragma mark - overided setter

- (void)setAnimationType:(JMAnimatedImageViewAnimationType)animationType
{
    _animationType = animationType;
    [self addGesturesForAnimationType:animationType];
}

#pragma mark -

- (void)reloadAnimationImages
{
    //Load the 1st
    [self setCurrentCardImageAtindex:0];
    [self addGesturesForAnimationType:_animationType];
}

- (void)addGesturesForAnimationType:(JMAnimatedImageViewAnimationType)animationType
{
    switch (animationType) {
        case JMAnimatedImageViewAnimationTypeManualSwipe:
            if (nil == self.panGesture) {
                self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouched:)];
                [self addGestureRecognizer:self.panGesture];
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

- (void)imageViewTouchedWithPanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s",__FUNCTION__);
    [self cancelAnimations];
    
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    NSInteger index = [self currentIndex];
    NSLog(@"velocity %@",NSStringFromCGPoint(velocity));
    
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

- (void)setCurrentCardImageAtindex:(NSInteger)index
{
        NSLog(@"%s index:%d",__FUNCTION__,(int)index);
        NSInteger realIndex = [self realIndexForComputedIndex:index];
        
        NSString *imageName = [self.animationDatasource imageNameAtIndex:realIndex forAnimatedImageView:self];
        self.image = [UIImage jm_imageNamed:imageName withOption:self.memoryManagementOption];
        self.currentIndex = realIndex;
}

- (void)setCurrentImage:(UIImage *)img forIndex:(NSInteger)index
{
    NSLog(@"%s index:%d",__FUNCTION__,(int)index);
    NSInteger realIndex = [self realIndexForComputedIndex:index];
    self.image = img;
    self.currentIndex = realIndex;
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

- (void)cancelAnimations
{
    NSLog(@"Cancel %d operations ", (int)[[self.animationQueue operations] count]);
    for (NSOperation* o in [self.animationQueue operations]) {
        if ([o isKindOfClass:[o class]]) {
            [o cancel];
        }
    }
}

#pragma mark - Manage Automatic 

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



@end
