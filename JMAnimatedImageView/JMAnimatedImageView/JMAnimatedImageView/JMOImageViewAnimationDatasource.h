//
//  JMOImageViewAnimationDatasource.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMOImageViewAnimationDatasource <NSObject>

- (NSInteger)numberOfImagesForAnimatedImageView:(UIImageView *)imageView;
- (NSString *)imageNameAtIndex:(NSInteger)index forAnimatedImageView:(UIImageView *)imageView;

@optional
- (NSInteger)firstIndexForAnimatedImageView:(UIImageView *)imageView;
- (UIImage *)imageAtIndex:(NSInteger)index forAnimatedImageView:(UIImageView *)imageView;

@end
