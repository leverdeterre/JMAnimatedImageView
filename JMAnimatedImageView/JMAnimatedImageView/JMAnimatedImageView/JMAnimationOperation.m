//
//  AnimationOperation.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimationOperation.h"

@interface JMAnimationOperation ()
@property (assign, nonatomic) BOOL isCancelled;
@property (assign, nonatomic) BOOL isExecuting;
@property (assign, nonatomic) BOOL isFinished;
@end

@implementation JMAnimationOperation

+ (instancetype)animationOperationWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
    JMAnimationOperation *op = [JMAnimationOperation new];
    op.animationBlock = animations;
    JMCompletionBlock completionBlock = ^(BOOL finish){
        //NSLog(@"Operation is about to finished.");
        [op finish];
        if (completion) {
            completion(finish);
        }
    };
    
    op.duration = duration;
    op.completionBlock = completionBlock;
    return op;
}

- (BOOL)isConcurrent
{
    return NO;
}

- (void)start
{    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    
    if (_isCancelled == YES)
    {
        _isFinished = YES;
    }
    else
    {
        //NSLog(@"Operation of duration: %lf started.",self.duration);
        if (self.animationBlock) {
            
            [NSThread sleepForTimeInterval:self.duration];
            self.animationBlock();
            self.completionBlock(YES);
            
        }
    }
}

- (void)finish
{
    //NSLog(@"operationfinished.");
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    if (_isCancelled == YES)
    {
        _isFinished = YES;
    }
}

- (void)cancel
{
    //NSLog(@"** OPERATION CANCELED **");
    _isCancelled = YES;
    _isFinished = YES;
}

@end
