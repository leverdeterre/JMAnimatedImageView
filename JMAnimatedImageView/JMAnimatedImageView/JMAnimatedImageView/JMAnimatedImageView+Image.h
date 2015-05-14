//
//  JMAnimatedImageView+Image.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 20/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimatedImageView.h"

@interface JMAnimatedImageView (Image)

/**
 *  imageAtIndex: This method help to get the image for an index
 *
 *  @param index NSInteger
 *
 *  @return UIImage image
 */
- (UIImage *)imageAtIndex:(NSInteger)index;

/**
 *  numberOfImages. This method return the number of images
 *
 *  @return NSUInteger numberOfImages
 */
- (NSUInteger)numberOfImages;

@end
