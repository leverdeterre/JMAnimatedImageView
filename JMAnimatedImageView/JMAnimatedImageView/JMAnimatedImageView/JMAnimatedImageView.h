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


typedef NS_ENUM(NSUInteger, JMAnimatedImageViewAnimationType) {
    JMAnimatedImageViewAnimationTypeManualRealTime = 0,
    JMAnimatedImageViewAnimationTypeManualSwipe,
    JMAnimatedImageViewAnimationTypeAutomaticLinear,  //use animationDuration + animationRepeatCount
    JMAnimatedImageViewAnimationTypeAutomaticReverse,  //use animationDuration + animationRepeatCount
};

typedef NS_ENUM(NSUInteger, JMAnimatedImageViewMemoryOption) {
    JMAnimatedImageViewMemoryLoadImageSystemCache = 0,  //images memory will be retain by system
    JMAnimatedImageViewMemoryLoadImageLowMemoryUsage,   //images loaded but not retained by the system
    JMAnimatedImageViewMemoryLoadImageCustom            //images loaded by you (JMOImageViewAnimationDatasource)
};

typedef NS_ENUM(NSUInteger, JMAnimatedImageViewOrder) {
    JMAnimatedImageViewOrderNone = 0,
    JMAnimatedImageViewOrderNormal = 1,
    JMAnimatedImageViewOrderReverse = -1
};

@interface JMAnimatedImageView : UIImageView

@property (weak, nonatomic) IBOutlet id <JMOImageViewAnimationDatasource> animationDatasource;
@property (weak, nonatomic) IBOutlet id <JMOImageViewAnimationDelegate> animationDelegate;
@property (assign, nonatomic) JMAnimatedImageViewAnimationType animationType;
@property (assign, nonatomic) JMAnimatedImageViewMemoryOption memoryManagementOption;
@property (assign, nonatomic) JMAnimatedImageViewOrder imageOrder;

- (void)reloadAnimationImages;

@end
