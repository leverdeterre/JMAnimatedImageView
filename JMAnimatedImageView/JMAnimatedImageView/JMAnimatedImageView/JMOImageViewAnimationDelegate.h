//
//  JMOImageViewAnimationDelegate.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMOImageViewAnimationDelegate <NSObject>

@optional
- (void)imageViewDidEndDragging:(UIImageView *)imageView withVelocity:(CGPoint)velocity targetIndex:(inout NSInteger *)targetIndex;

@end
