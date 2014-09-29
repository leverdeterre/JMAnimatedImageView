//
//  JMAnimatedImageView+JMGif.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 26/09/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimatedImageView.h"
#import "JMGif.h"

@interface JMAnimatedImageView (JMGif)

//Specific to GIF
@property (strong, readonly, nonatomic) JMGif *gifObject;

/**
 *  isAGifImageView
 *
 *  @return BOOL
 */
- (BOOL)isAGifImageView;

/**
 *  reloadAnimationImagesFromGifData:, This method reload a GIF image from a GIF NSData
 *
 *  @param data NSData data
 */
- (void)reloadAnimationImagesFromGifData:(NSData *)data;

/**
 *  reloadAnimationImagesFromGifNamed:, This method reload a GIF image from a GIF named
 *
 *  @param gitName NSString gitName
 */
- (void)reloadAnimationImagesFromGifNamed:(NSString *)gitName;


@end
