//
//  JMGif.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 20/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMGif.h"
#import "UIImage+JM.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreGraphics/CoreGraphics.h>
#import "JMAmimatedImageViewMacro.h"

@interface JMGif ()
@end

@implementation JMGif

- (instancetype)initWithData:(NSData *)data gifName:(NSString *)gifName
{
    self = [super init];
    if (self) {
        [self loadGifWithData:data gifName:gifName];
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    return [self initWithData:data gifName:nil];
}

+ (instancetype)gifNamed:(NSString *)gifName
{
    NSError *error;
    NSURL *url = [[NSBundle mainBundle] URLForResource:gifName withExtension:@"gif"];
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (nil == error) {
        JMGif *gif = [[JMGif alloc] initWithData:data gifName:gifName];
        return gif;
    }
    
    return nil;
}

- (void)loadGifWithData:(NSData *)data gifName:(NSString *)gifName
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    if (!imageSource) {
        JMOLog(@"Error: Failed to `CGImageSourceCreateWithData` for animated GIF data %@", data);
        return;
    }
    
    // Early return if not GIF!
    CFStringRef imageSourceContainerType = CGImageSourceGetType(imageSource);
    if (!UTTypeConformsTo(imageSourceContainerType, kUTTypeGIF)) {
        JMOLog(@"Error: Supplied data is of type %@ and doesn't seem to be GIF data %@", imageSourceContainerType, data);
        CFRelease(imageSource);
        return;
    }
    
    // Get `LoopCount`
    // Note: 0 means repeating the animation indefinitely.
    // Image properties example:
    // {
    //     FileSize = 314446;
    //     "{GIF}" = {
    //         HasGlobalColorMap = 1;
    //         LoopCount = 0;
    //     };
    // }

    // Iterate through frame images
    size_t imageCount = CGImageSourceGetCount(imageSource);
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:imageCount];
    for (size_t i = 0; i < imageCount; i++) {
        CGImageRef frameImageRef = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
        if (frameImageRef) {
            //UIImage *frameImage = [UIImage imageWithCGImage:frameImageRef];
            // Check for valid `frameImage` before parsing its properties as frames can be corrupted (and `frameImage` even `nil` when `frameImageRef` was valid).
            if (YES) {
                NSDictionary *frameProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageSource, i, NULL);
                NSDictionary *framePropertiesGIF = [frameProperties objectForKey:(id)kCGImagePropertyGIFDictionary];
                JMGifItem *item;
                if (gifName) {
                    item = [[JMGifItem alloc] initWithImagePath:[self.class imagePathForeGifName:gifName index:i]
                                                frameProperties:framePropertiesGIF];
                    if ([self.class gifNamedAlreadyCached:gifName index:i] == NO) {
                        [self.class cacheGifName:gifName image:[UIImage imageWithCGImage:frameImageRef] representingIndex:i];
                    }
                } else {
                    item = [[JMGifItem alloc] initWithImage:[UIImage imageWithCGImage:frameImageRef] frameProperties:framePropertiesGIF];
                }
      
                [items addObject:item];
            }
            
            CFRelease(frameImageRef);
        }
    }

    _items = items;
    CFRelease(imageSource);
}

- (UIImage *)imageAtIndex:(NSInteger)index
{
    JMGifItem *item = [self.items objectAtIndex:index];
    if (item.image) {
        return item.image;
        
    } else if (item.imagePath) {
        return [UIImage jm_imagePath:item.imagePath withOption:JMAnimatedImageViewMemoryLoadImageLowMemoryUsage];
    }
    
    return nil;
}

#pragma mark - Gif cache management

+ (BOOL)gifNamedAlreadyCached:(NSString *)gifName
{
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",[self cacheDirectoryPath],gifName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)gifNamedAlreadyCached:(NSString *)gifName index:(NSInteger)index
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self imagePathForeGifName:gifName index:index]]) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)cacheDirectoryPath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",cachePath,@"JMAnimatedImageView"];
    return directoryPath;
}

+ (BOOL)cleanGifCache
{
    NSError *cleanError;
    return [[NSFileManager defaultManager] removeItemAtPath:[self cacheDirectoryPath] error:&cleanError];
}

+ (BOOL)cleanGifCacheError:(NSError **)error
{
    return [[NSFileManager defaultManager] removeItemAtPath:[self cacheDirectoryPath] error:error];
}

+ (BOOL)cleanGifCacheForGifNamed:(NSString *)gifName
{
    NSError *cleanError;
    return [self cleanGifCacheForGifNamed:gifName error:&cleanError];
}

+ (BOOL)cleanGifCacheForGifNamed:(NSString *)gifName error:(NSError **)error
{
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",[self cacheDirectoryPath],gifName];
    return [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:error];
}

+ (NSString *)imagePathForeGifName:(NSString *)gifName index:(NSInteger)index
{
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",[self cacheDirectoryPath],gifName];
    NSString *filePath = [NSString stringWithFormat:@"%@/%ld.png",directoryPath,(long)index];
    return filePath;
}

+ (void)cacheGifName:(NSString *)gifName image:(UIImage *)img representingIndex:(NSInteger)index
{
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@",[self cacheDirectoryPath],gifName];
    
    BOOL isDirectory = NO;
    if (! [[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory]) {
        
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtURL:[NSURL fileURLWithPath:directoryPath]
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:&error];
    }
    
    NSData *data = UIImagePNGRepresentation(img);
    if (data) {
        NSString *imgPath = [self imagePathForeGifName:gifName index:index];
        NSError *writeError;
        [data writeToFile:imgPath options:0 error:&writeError];
    }
}

@end


@interface JMGifItem ()
@property (readonly, nonatomic) NSDictionary *delay;
@end

@implementation JMGifItem

- (NSTimeInterval)delayDuration
{
    NSNumber *delay = [_delay objectForKey:JMGifItemUnclampedDelayTimeKey];
    if (nil == delay) {
        delay = [_delay objectForKey:JMGifItemDelayTimeKey];
    }
    
    NSTimeInterval valueToReturn = [delay doubleValue];
    if (valueToReturn < 0.011f) {
        // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
        // for more information.
        valueToReturn = 0.100f;
    }
    
    return valueToReturn;
}

- (instancetype)initWithImage:(UIImage *)image frameProperties:(NSDictionary *)frameProperties
{
    return [self initWithImage:image imagePath:nil frameProperties:frameProperties];
}

- (instancetype)initWithImagePath:(NSString *)imagePath frameProperties:(NSDictionary *)frameProperties
{
    return [self initWithImage:nil imagePath:imagePath frameProperties:frameProperties];
}

- (instancetype)initWithImage:(UIImage *)image imagePath:(NSString *)imagePath frameProperties:(NSDictionary *)frameProperties
{
    self = [super init];
    if (self) {
        _image = image;
        // Get `DelayTime`
        // Note: It's not in (1/100) of a second like still falsly described in the documentation as per iOS 7 but in seconds stored as `kCFNumberFloat32Type`.
        // Frame properties example:
        // {
        //     ColorModel = RGB;
        //     Depth = 8;
        //     PixelHeight = 960;
        //     PixelWidth = 640;
        //     "{GIF}" = {
        //         DelayTime = "0.4";
        //         UnclampedDelayTime = "0.4";
        //     };
        // }
        _delay = frameProperties;
        _imagePath = imagePath;
    }
    return self;
}

@end
