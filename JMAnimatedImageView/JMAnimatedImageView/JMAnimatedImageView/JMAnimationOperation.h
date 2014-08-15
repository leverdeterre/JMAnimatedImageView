//
//  AnimationOperation.h
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JMCompletionBlock)(BOOL finished);
typedef void (^JMAnimationBlock)(void);

@interface JMAnimationOperation : NSOperation

@property (copy, nonatomic) JMAnimationBlock animationBlock;
@property (copy, nonatomic) JMCompletionBlock completionBlock;
@property (assign, nonatomic) NSTimeInterval duration;

@property (strong, nonatomic) NSString *imageName;

+ (instancetype)animationOperationWithDuration:(NSTimeInterval)duration
                                    animations:(void (^)(void))animations
                                    completion:(void (^)(BOOL finished))completion;

@end
