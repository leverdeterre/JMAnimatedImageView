//
//  JMAnimatedImageView.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMOImageViewAnimationDelegate.h"
#import "JMOImageViewAnimationDatasource.h"

#define JMDefaultGifDuration -1

typedef NS_ENUM(NSUInteger, JMAnimatedImageViewAnimationType) {
    JMAnimatedImageViewAnimationTypeInteractive = 0,
    JMAnimatedImageViewAnimationTypeManualSwipe,
    JMAnimatedImageViewAnimationTypeAutomaticLinear,                    //use animationDuration + animationRepeatCount
    JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition,   //use animationDuration + animationRepeatCount
    JMAnimatedImageViewAnimationTypeAutomaticReverse                    //use animationDuration + animationRepeatCount
};

typedef NS_ENUM(NSUInteger, JMAnimatedImageViewMemoryOption) {
    JMAnimatedImageViewMemoryLoadImageSystemCache = 0,  //images memory will be retain by system
    JMAnimatedImageViewMemoryLoadImageLowMemoryUsage,   //images loaded but not retained by the system
    JMAnimatedImageViewMemoryLoadImageCustom            //images loaded by you (JMOImageViewAnimationDatasource)
};

typedef NS_ENUM(NSUInteger, JMAnimatedImageViewOrder) {
    JMAnimatedImageViewOrderNormal = 1,
    JMAnimatedImageViewOrderReverse = -1
};

typedef NS_ENUM(NSUInteger, UIImageViewAnimationOption) {
    UIImageViewAnimationOptionLinear = 0,
    UIImageViewAnimationOptionCurveEaseInOut
};

typedef NS_ENUM(NSUInteger, UIImageViewAnimationState) {
    UIImageViewAnimationStateStopped = 0,
    UIImageViewAnimationStateInPgrogress
};

typedef void (^JMCompletionFinishBlock)(BOOL resul);

@interface JMAnimatedImageView : UIImageView

@property (weak, nonatomic) IBOutlet id <JMOImageViewAnimationDatasource> animationDatasource;
@property (weak, nonatomic) IBOutlet id <JMOImageViewAnimationDelegate> animationDelegate;
@property (assign, nonatomic) JMAnimatedImageViewAnimationType animationType;
@property (assign, nonatomic) JMAnimatedImageViewMemoryOption memoryManagementOption;
@property (assign, nonatomic) JMAnimatedImageViewOrder imageOrder;
@property (assign, nonatomic) BOOL interactiveAnimation;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) UIImageViewAnimationState animationState;
@property (strong, nonatomic, readonly) dispatch_queue_t animationManagementQueue;
@property (strong, nonatomic, readonly) NSOperationQueue *animationQueue;

/**
 * reloadAnimationImages, This method will call animationDatasource
 */
- (void)reloadAnimationImages;

/**
 *  setCurrentIndex, This method will animate the modification of image
 *
 *  @param index    destination index
 *  @param animated BOOL animated
 */
- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;

/**
 *  setImage, This method will force the image to the index
 *
 *  @param img   UIImage
 *  @param index NSInteger index
 */
- (void)setImage:(UIImage *)img forCurrentIndex:(NSInteger)index;

/**
 *  animateToIndex:withDuration:, This method will animate the modification of images to access to the index in parameter.
 *
 *  @param index    NSInteger destination index
 *  @param duration NSTimeInterval duration
 */
- (void)animateToIndex:(NSInteger)index withDuration:(NSTimeInterval)duration;

/**
 *  animateToIndex:withDuration:withCompletionBlock:, This method will animate the modification of images to access to the index in parameter.
 *
 *  @param index    NSInteger destination index
 *  @param duration NSTimeInterval duration
 *  @param finishBlock JMCompletionFinishBlock CompletionBlock
 */
- (void)animateToIndex:(NSInteger)index withDuration:(NSTimeInterval)duration withCompletionBlock:(JMCompletionFinishBlock)finishBlock;

- (void)updateGestures;
- (void)changeImageToIndex:(NSInteger)index withTimeInterval:(NSTimeInterval)duration repeat:(BOOL)repeat;
- (BOOL)operationQueueIsFinished;
- (BOOL)checkLifeCycleSanity;
- (NSInteger)realIndexForComputedIndex:(NSInteger)index;

@end
