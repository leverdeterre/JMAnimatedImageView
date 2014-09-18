//
//  UIImage+JM.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMAnimatedImageView.h"

@interface UIImage (JM)

/**
 *  jm_imageNamed:, This method return an UIImage for a imageName, using default system cache
 *
 *  @param name NSString, image name
 *
 *  @return UIImage
 */
+ (UIImage *)jm_imageNamed:(NSString *)name;

/**
 *  jm_imageNamed:withOption:, This method return an UIImage for a imageName, using a specific MemoryOption
 *
 *  @param name NSString, image name
 *  @param option JMAnimatedImageViewMemoryOption option
 *
 *  @return UIImage
 */
+ (UIImage *)jm_imageNamed:(NSString *)name withOption:(JMAnimatedImageViewMemoryOption)option;

/**
 *  jm_imagePath:withOption:, This method return an UIImage for a imagePath, using a specific MemoryOption
 *
 *  @param imagePath NSString, image path
 *  @param option JMAnimatedImageViewMemoryOption option
 *
 *  @return UIImage
 */
+ (UIImage *)jm_imagePath:(NSString *)imagePath withOption:(JMAnimatedImageViewMemoryOption)option;

@end
