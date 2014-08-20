//
//  JMAnimatedImageView+Image.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 20/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimatedImageView+Image.h"
#import "UIImage+JM.h"

@implementation JMAnimatedImageView (Image)

- (UIImage *)imageAtIndex:(NSInteger)index
{
    if ([self isAGifImageView]) {
        return [self.gifObject imageAtIndex:index];
        
    } else if ([self.animationDatasource respondsToSelector:@selector(imageAtIndex:forAnimatedImageView:)]) {
        return [self.animationDatasource imageAtIndex:index forAnimatedImageView:self];
        
    } else if ([self.animationDatasource respondsToSelector:@selector(imageNameAtIndex:forAnimatedImageView:)]) {
        NSString *imgName = [self.animationDatasource imageNameAtIndex:index forAnimatedImageView:self];
        UIImage *img = [UIImage jm_imageNamed:imgName withOption:self.memoryManagementOption];
        return img;
    }
    
    return nil;
}

@end
