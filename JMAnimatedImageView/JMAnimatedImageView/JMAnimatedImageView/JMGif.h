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
@property (readonly, nonatomic) NSURL *url;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithData:(NSData *)data fromURL:(NSURL *)url;
+ (instancetype)gifNamed:(NSString *)gifName;

- (UIImage *)imageAtIndex:(NSInteger)index;

+ (BOOL)cleanGifCache;
+ (BOOL)cleanGifCacheError:(NSError **)error;
+ (BOOL)cleanGifCacheForGifNamed:(NSString *)gifName;
+ (BOOL)cleanGifCacheForGifNamed:(NSString *)gifName error:(NSError **)error;
+ (void)cacheGifData:(NSData *)data gifAbsoluteUrl:(NSString *)absoluteUrl;

@end



#define JMGifItemDelayTimeKey @"DelayTime"
#define JMGifItemUnclampedDelayTimeKey @"UnclampedDelayTime"

@interface JMGifItem : NSObject

@property (readonly, nonatomic) UIImage *image;
@property (readonly, nonatomic) NSString *imagePath;
@property (readonly, nonatomic) NSTimeInterval delayDuration;

- (instancetype)initWithImage:(UIImage *)image frameProperties:(NSDictionary *)frameProperties;
- (instancetype)initWithImagePath:(NSString *)imagePath frameProperties:(NSDictionary *)frameProperties;
- (instancetype)initWithImage:(UIImage *)image imagePath:(NSString *)imagePath frameProperties:(NSDictionary *)frameProperties;

@end
