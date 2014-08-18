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
- (void)imageView:(UIImageView *)imageView didEndDraggingWithVelocity:(CGPoint)velocity targetIndex:(inout NSInteger *)targetIndex;
- (void)imageView:(UIImageView *)imageView didChangeCurrentindex:(NSInteger)index;

@end
