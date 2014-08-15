JMAnimatedImageView 
==================

Subclass of UIImageView to drive easy animations.

Some parameters : 

* AnimationType
```objc
typedef NS_ENUM(NSUInteger, JMAnimatedImageViewAnimationType) {
    JMAnimatedImageViewAnimationTypeManualRealTime = 0, //Animation is done by a Pan gesture
    JMAnimatedImageViewAnimationTypeManualSwipe,        //Animation, carousel effect
    JMAnimatedImageViewAnimationTypeAutomaticLinear,    //Automatic rotation, use animationDuration + animationRepeatCount
    JMAnimatedImageViewAnimationTypeAutomaticReverse,   //Automatic rotation, use animationDuration + animationRepeatCount
};
```

* MemoryOption
```objc
typedef NS_ENUM(NSUInteger, JMAnimatedImageViewMemoryOption) {
    JMAnimatedImageViewMemoryLoadImageSystemCache = 0,  //images memory will be retain by system
    JMAnimatedImageViewMemoryLoadImageLowMemoryUsage
};
```

* ImageViewOrder

```objc
typedef NS_ENUM(NSUInteger, JMAnimatedImageViewOrder) {
    JMAnimatedImageViewOrderNone = 0,
    JMAnimatedImageViewOrderNormal = 1,
    JMAnimatedImageViewOrderReverse = -1
};
```
