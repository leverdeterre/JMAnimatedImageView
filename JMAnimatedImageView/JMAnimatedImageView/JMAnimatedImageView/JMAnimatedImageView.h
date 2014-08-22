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
#import "JMGif.h"

#define JMDefaultGifDuration -1

typedef NS_ENUM(NSUInteger, JMAnimatedImageViewAnimationType) {
    JMAnimatedImageViewAnimationTypeInteractive = 0,
    JMAnimatedImageViewAnimationTypeManualSwipe,
    JMAnimatedImageViewAnimationTypeAutomaticLinear,                    //use animationDuration + animationRepeatCount
    JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutAnimation,    //use animationDuration + animationRepeatCount
    JMAnimatedImageViewAnimationTypeAutomaticReverse,                   //use animationDuration + animationRepeatCount
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

@interface JMAnimatedImageView : UIImageView

@property (weak, nonatomic) IBOutlet id <JMOImageViewAnimationDatasource> animationDatasource;
@property (weak, nonatomic) IBOutlet id <JMOImageViewAnimationDelegate> animationDelegate;
@property (assign, nonatomic) JMAnimatedImageViewAnimationType animationType;
@property (assign, nonatomic) JMAnimatedImageViewMemoryOption memoryManagementOption;
@property (assign, nonatomic) JMAnimatedImageViewOrder imageOrder;

//Specific to GIF
@property (strong, readonly, nonatomic) JMGif *gifObject;

- (void)reloadAnimationImages;
- (void)reloadAnimationImagesFromGifData:(NSData *)data;
- (void)reloadAnimationImagesFromGifNamed:(NSString *)gitName;

- (void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setImage:(UIImage *)img forCurrentIndex:(NSInteger)index;
- (void)animateToIndex:(NSInteger)index withDuration:(NSTimeInterval)duration;

- (BOOL)isAGifImageView;

@end
