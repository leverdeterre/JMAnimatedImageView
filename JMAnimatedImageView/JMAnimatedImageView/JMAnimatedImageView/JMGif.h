//
//  JMGif.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 20/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JMGif : NSObject
@property (readonly, nonatomic) NSArray *items;  //images + infos

- (instancetype)initWithData:(NSData *)data;

@end



#define JMGifItemDelayTimeKey @"DelayTime"
#define JMGifItemUnclampedDelayTimeKey @"UnclampedDelayTime"

@interface JMGifItem : NSObject

@property (readonly, nonatomic) UIImage *image;
@property (readonly, nonatomic) NSDictionary *delay;

- (instancetype)initWithImage:(UIImage *)image frameProperties:(NSDictionary *)frameProperties;

@end
