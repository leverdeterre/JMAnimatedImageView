//
//  JMViewController.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMAnimatedImageView.h"

@interface JMViewController : UIViewController

@property (assign, nonatomic) JMAnimatedImageViewAnimationType animationType;
@property (assign, nonatomic) JMAnimatedImageViewMemoryOption memoryManagementOption;
@property (assign, nonatomic) BOOL useJMImageView;
@property (assign, nonatomic) JMAnimatedImageViewOrder order;
@end
