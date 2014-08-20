//
//  AnimationOperation.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimationOperation.h"
#import "JMAnimatedImageView.h"
#import "UIImage+JM.h"
#import "JMAnimatedImageView+Image.h"

#include <sys/time.h>
#import<malloc/malloc.h>

long getMillis()
{
    struct timeval time;
    gettimeofday(&time, NULL);
    long millis = (time.tv_sec * 1000) + (time.tv_usec / 1000);
    return millis;
}

@interface JMAnimationOperation ()
@property (assign, nonatomic) BOOL isCancelled;
@property (assign, nonatomic) BOOL isExecuting;
@property (assign, nonatomic) BOOL isFinished;
@end

@implementation JMAnimationOperation

+ (instancetype)animationOperationWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL finished))completion
{
    JMAnimationOperation *op = [JMAnimationOperation new];
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
    else {
        
        
        long timeStart = getMillis();
       
        UIImage *image = [self.animatedImageView imageAtIndex:self.imageIndex];
  
        long timeEnd = getMillis();
        long diff = timeEnd - timeStart;
        double millisToLoadImage = (diff/1000.0);
        
        //Compute number of Millis to load an image and fix self.duration
        if (millisToLoadImage < self.duration) {
            [NSThread sleepForTimeInterval:(self.duration - millisToLoadImage)];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.animatedImageView setImage:image forCurrentIndex:self.imageIndex];
                self.completionBlock(YES);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.animatedImageView setImage:image forCurrentIndex:self.imageIndex];
                self.completionBlock(YES);
            });
        }
    }
}

- (void)finish
{
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
    _isCancelled = YES;
    _isFinished = YES;
}

@end
