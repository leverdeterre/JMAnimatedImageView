//
//  JMTableViewController.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, JMDemoType) {
    JMDemoAutomatic =                   1,
    JMDemoInteractive =                 1 << 1,
    JMDemoChangeImageSwipeTransition =  1 << 2,
    JMDemoChangeImageNoTransition =     1 << 3,
    JMDemoMemoryBySystem =              1 << 4,
    JMDemoMemoryByMyComponent =         1 << 5,
    JMDemoReverseImage        =         1 << 6,
    JMDemoPhotos        =               1 << 8
};

@interface JMTableViewController : UITableViewController

@end
