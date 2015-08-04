## My other works

[http://leverdeterre.github.io] (http://leverdeterre.github.io)

JMAnimatedImageView 
==================

JMAnimatedImageView is a performant subclass of UIImageView:

- Plays huge image animation using a minimum memory pressure,
- Allows manual interactions with imageView to drive manualy animations,
- Can use has a Carousel, 
- GIF are supported to load your animations.

## Change Log

0.2.4 : 

- Improve documentation
- Fix retain cycle (Thanks Instruments!)
- JMGif allocation for a better integration with your favorites network libraries.


## Installation 

Simply replace your `UIImageView` instances with instances of `JMAnimatedImageView`.

If using CocoaPods, the quickest way to try it out is to type this on the command line:

```shell
$ pod try JMAnimatedImageView
```

## Usage
### For a local animation using file from a bundle

In your code, `#import "JMAnimatedImageView.h"` and `#import "JMAnimatedImageView.h"` 

```objective-c
//GIF example
@property (weak, nonatomic) IBOutlet JMAnimatedImageView *jmImageView;

[self.jmImageView reloadAnimationImagesFromGifNamed:@"rock"];
self.jmImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
[self.jmImageView startAnimating];
```

```objective-c
//PNG example with manual animation
@property (weak, nonatomic) IBOutlet JMAnimatedImageView *jmImageView;

self.jmImageView.animationDelegate = self;
self.jmImageView.animationDatasource = self;
[self.jmImageView reloadAnimationImages]; //<JMOImageViewAnimationDatasource>
self.jmImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
self.jmImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
[self.jmImageView startAnimating];
```

### For a remote Gif

```objective-c
@property (weak, nonatomic) IBOutlet JMAnimatedImageView *jmImageView;

[[JMApi sharedApi] downloadYourGifFileHasData:^(NSData *gifData) {
	self.animatedImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
    self.animatedImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
   	[self.animatedImageView reloadAnimationImagesFromGifData:gifData fromUrl:url];
     [self.animatedImageView startAnimating];
}];	
```
### For a remote Gif using AFNetworking

```objective-c
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
	
    AFHTTPRequestOperation *postOperation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [postOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		self.animatedImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
    	self.animatedImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
   		[self.animatedImageView reloadAnimationImagesFromGifData:responseObject fromUrl:url];
     	[self.animatedImageView startAnimating];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        block(NO, nil);
    }];
    
	[postOperation start];
```

### Customizations 

* AnimationType

```objective-c
typedef NS_ENUM(NSUInteger, JMAnimatedImageViewAnimationType) {
    JMAnimatedImageViewAnimationTypeInteractive = 0,
    
    //Animation, carousel effect
    JMAnimatedImageViewAnimationTypeManualSwipe,
    
    //Automatic rotation, use animationDuration + animationRepeatCount
    JMAnimatedImageViewAnimationTypeAutomaticLinear,    
    JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition,
    JMAnimatedImageViewAnimationTypeAutomaticReverse,
};
```

* MemoryOption

```objective-c
typedef NS_ENUM(NSUInteger, JMAnimatedImageViewMemoryOption) {
    JMAnimatedImageViewMemoryLoadImageSystemCache = 0,  //images memory will be retain by system
    JMAnimatedImageViewMemoryLoadImageLowMemoryUsage,   //images loaded but not retained by the system
    JMAnimatedImageViewMemoryLoadImageCustom            //images loaded by you (JMOImageViewAnimationDatasource)
};
```

* ImageViewOrder

```objective-c
typedef NS_ENUM(NSUInteger, JMAnimatedImageViewOrder) {
    JMAnimatedImageViewOrderNormal = 1,
    JMAnimatedImageViewOrderReverse = -1
};
```

## Multi Gif and animation type (top interactive, leff automatic swipe effect, right automatic without animation)

![Image](./Screens/gif_experiments.gif "Multi Gif")

##  JMimageView can generate Carousels

![Image](./Screens/JMimageViewCarousel.gif "Carousel Demo")

##  JMimageView allows interactive animations

![Image](./Screens/JMImageViewRotation.gif "Rotation Demo")

## TODO
* Add support for APNG 
* Add support for WebP animated (work in progress but this feature is not actually supported : https://chromium.googlesource.com/webm/libwebp/) 
* * Add support for video format ?  



