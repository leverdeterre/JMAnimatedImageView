//
//  JMAnimatedImageView+JMGif.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 26/09/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimatedImageView+JMGif.h"
#import <objc/runtime.h>

//JMGif *gifObject

@implementation JMAnimatedImageView (JMGif)

- (JMGif *)gifObject
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setGifObject:(JMGif *)gifObject
{
    objc_setAssociatedObject(self, @selector(gifObject), gifObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isAGifImageView
{
    if (self.gifObject) {
        return YES;
    }
    return NO;
}

- (void)reloadAnimationImagesFromGifData:(NSData *)data
{
    self.gifObject = [[JMGif alloc] initWithData:data];
    self.animationDuration = JMDefaultGifDuration;
    [self setCurrentIndex:0];
}

- (void)reloadAnimationImagesFromGifNamed:(NSString *)gitName
{
    self.gifObject = [JMGif gifNamed:gitName];
    self.animationDuration = JMDefaultGifDuration;
    [self setCurrentIndex:0];
    [self updateGestures];
}

@end
