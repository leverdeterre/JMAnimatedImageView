//
//  JMGif.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 20/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMGif.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation JMGif

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        [self loadGifWithData:data];
    }
    return self;
}

- (void)loadGifWithData:(NSData *)data
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    if (!imageSource) {
        NSLog(@"Error: Failed to `CGImageSourceCreateWithData` for animated GIF data %@", data);
        return;
    }
    
    // Early return if not GIF!
    CFStringRef imageSourceContainerType = CGImageSourceGetType(imageSource);
    if (!UTTypeConformsTo(imageSourceContainerType, kUTTypeGIF)) {
        NSLog(@"Error: Supplied data is of type %@ and doesn't seem to be GIF data %@", imageSourceContainerType, data);
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
            UIImage *frameImage = [UIImage imageWithCGImage:frameImageRef];
            // Check for valid `frameImage` before parsing its properties as frames can be corrupted (and `frameImage` even `nil` when `frameImageRef` was valid).
            if (frameImage) {
                NSDictionary *frameProperties = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageSource, i, NULL);
                NSDictionary *framePropertiesGIF = [frameProperties objectForKey:(id)kCGImagePropertyGIFDictionary];
                JMGifItem *item = [[JMGifItem alloc] initWithImage:frameImage frameProperties:framePropertiesGIF];
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
    return [[self.items objectAtIndex:index] image];
}

@end


@implementation JMGifItem

- (instancetype)initWithImage:(UIImage *)image frameProperties:(NSDictionary *)frameProperties
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
    }
    return self;
}

@end
