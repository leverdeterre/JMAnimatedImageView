//
//  UIImage+JM.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "UIImage+JM.h"

@implementation UIImage (JM)

+ (UIImage *)jm_imageNamed:(NSString *)name
{
    if (nil == name) {
        return nil;
    }
    return [self jm_imageNamed:name withOption:JMAnimatedImageViewMemoryLoadImageSystemCache];
}

+ (UIImage *)jm_imageNamed:(NSString *)name withOption:(JMAnimatedImageViewMemoryOption)option
{
    if (nil == name) {
        return nil;
    }
    
    if (option == JMAnimatedImageViewMemoryLoadImageSystemCache) {
        return [UIImage imageNamed:name];
    } else {
        NSString *extension = [name pathExtension];
        NSString *nameWithoutExtension = [name stringByDeletingPathExtension];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:nameWithoutExtension ofType:extension];
        return [UIImage imageWithContentsOfFile:filePath];
    }
}

@end
