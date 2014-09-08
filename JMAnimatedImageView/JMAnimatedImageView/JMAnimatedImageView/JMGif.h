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
+ (instancetype)gifNamed:(NSString *)gifName;

- (UIImage *)imageAtIndex:(NSInteger)index;

+ (BOOL)cleanGifCache;
+ (BOOL)cleanGifCacheError:(NSError **)error;
+ (BOOL)cleanGifCacheForGifNamed:(NSString *)gifName;
+ (BOOL)cleanGifCacheForGifNamed:(NSString *)gifName error:(NSError **)error;

@end



#define JMGifItemDelayTimeKey @"DelayTime"
#define JMGifItemUnclampedDelayTimeKey @"UnclampedDelayTime"

@interface JMGifItem : NSObject

@property (readonly, nonatomic) UIImage *image;
@property (readonly, nonatomic) NSString *imagePath;
@property (readonly, nonatomic) NSDictionary *delay;

- (instancetype)initWithImage:(UIImage *)image frameProperties:(NSDictionary *)frameProperties;
- (instancetype)initWithImagePath:(NSString *)imagePath frameProperties:(NSDictionary *)frameProperties;
- (instancetype)initWithImage:(UIImage *)image imagePath:(NSString *)imagePath frameProperties:(NSDictionary *)frameProperties;

@end
