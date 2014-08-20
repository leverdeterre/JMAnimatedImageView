//
//  JMAnimatedImageView+Image.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 20/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimatedImageView.h"

@interface JMAnimatedImageView (Image)

- (UIImage *)imageAtIndex:(NSInteger)index;
- (NSUInteger)numberOfImages;

@end
