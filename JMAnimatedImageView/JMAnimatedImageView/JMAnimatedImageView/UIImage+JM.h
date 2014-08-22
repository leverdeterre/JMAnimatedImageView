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

+ (UIImage *)jm_imageNamed:(NSString *)name;
+ (UIImage *)jm_imageNamed:(NSString *)name withOption:(JMAnimatedImageViewMemoryOption)option;
+ (UIImage *)jm_imagePath:(NSString *)imagePath withOption:(JMAnimatedImageViewMemoryOption)option;

@end
