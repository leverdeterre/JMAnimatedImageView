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

@class JMAnimatedImageView;
@interface JMAnimationOperation : NSOperation

@property (copy, nonatomic) JMCompletionBlock animationCompletionBlock;
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) NSInteger imageIndex;
@property (weak, nonatomic) JMAnimatedImageView *animatedImageView;

/**
 *  animationOperationWithDuration:completion: create an animated operation, JMAnimationOperation
 *
 *  @param duration   NSTimeInterval duration
 *  @param completion JMCompletionBlock completionBlock
 *
 *  @return JMAnimationOperation
 */
+ (instancetype)animationOperationWithDuration:(NSTimeInterval)duration
                                    completion:(JMCompletionBlock)completion;

@end
