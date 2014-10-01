//
//  JMTableViewController.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JMDemoType) {
    JMDemoAutomaticAnimationUsingImageViewImageAndSystemCache = 0,
    JMDemoAutomaticAnimationUsingJMAnimatedImageViewImageAndSystemCache,
    JMDemoAutomaticAnimationUsingJMAnimatedImageViewImageAndWithoutCache,
    JMDemoAutoSwipeAnimationUsingJMAnimatedImageViewImageAndWithoutCache,
    JMDemoInteractiveAnimationUsingJMAnimatedImageViewImageAndWithoutCache,
    JMDemoCarouselUsingJMAnimatedImageViewImageAndWithoutCache,
    JMDemoGIFAutomaticAnimationUsingImageViewImageLowMemoryPressure,
    JMDemoGIFInteractiveAnimationUsingImageViewImageLowMemoryPressure
};

@interface JMTableViewController : UITableViewController

@end
