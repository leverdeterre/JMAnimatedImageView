//
//  JMAppDelegate.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMRamViewController.h"

@interface JMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JMRamViewController* ramVc;

- (void)loadMemoryFollower;

@end
