//
//  JMAnimatedGifImageView.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 01/10/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMAnimatedGifImageView.h"
#import "JMAnimatedLog.h"
#import "JMAnimationOperation.h"

@implementation JMAnimatedGifImageView

- (BOOL)isAGifImageView
{
    if (self.gifObject) {
        return YES;
    }
    return NO;
}

- (void)reloadAnimationImagesFromGifData:(NSData *)data
{
    _gifObject = [[JMGif alloc] initWithData:data];
    self.animationDuration = JMDefaultGifDuration;
    [self setCurrentIndex:0];
}

- (void)reloadAnimationImagesFromGifNamed:(NSString *)gitName
{
    _gifObject = [JMGif gifNamed:gitName];
    self.animationDuration = JMDefaultGifDuration;
    [self setCurrentIndex:0];
    [self updateGestures];
}

- (void)moveCurrentCardImageFromIndex:(NSInteger)fromIndex
                                shift:(NSInteger)shift
                         withDuration:(NSTimeInterval)duration
                      animationOption:(UIImageViewAnimationOption)option
                  withCompletionBlock:(JMCompletionFinishBlock)finishBlock
{
    dispatch_async(self.animationManagementQueue, ^{
        
        NSTimeInterval unitDuration;
        NSInteger shiftUnit = shift / abs((int)shift); // 1 ou -1
        
        if (duration == JMDefaultGifDuration) {
            unitDuration = duration;
            
        } else {
            if (option == UIImageViewAnimationOptionLinear) {
                unitDuration = duration / abs((int)shift);
            } else {
                unitDuration = duration / abs((int)(shift * shift));
            }
        }
        
        JMLog(@"%s fromIndex:%d shift:%d duration:%lf",__FUNCTION__,(int)fromIndex,(int)shift,duration);
        
        //[self cancelAnimations];
        [self.animationQueue cancelAllOperations];
        [self.animationQueue waitUntilAllOperationsAreFinished];
        
        for (int i = 0; i < (int)abs((int)shift) ; i++) {
            
            NSInteger index = [self realIndexForComputedIndex:fromIndex+i*shiftUnit];
            JMGifItem *item = [[self.gifObject items] objectAtIndex:index];
            
            __weak JMAnimatedGifImageView *weaSelf = self;
            JMAnimationOperation *operation = [JMAnimationOperation animationOperationWithDuration:item.delayDuration
                                                                                        completion:^(BOOL finished)
                                               {
                                                   
                                                   if (weaSelf.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition) {
                                                       if ([weaSelf operationQueueIsFinished] == YES) {
                                                           if (finishBlock) {
                                                               finishBlock(YES);
                                                           }
                                                           
                                                           if (weaSelf.animationRepeatCount == 0 &&
                                                               weaSelf.animationState == UIImageViewAnimationStateInPgrogress) {
                                                               [weaSelf continueAnimating];
                                                           }
                                                       }
                                                   }
                                               }];
            
            operation.animatedImageView = self;
            operation.imageIndex = index;
            [self.animationQueue addOperation:operation];
        }
    });
}

- (void)startAnimating
{
    self.animationState = UIImageViewAnimationStateInPgrogress;
    
    if ([self checkLifeCycleSanity] == NO) {
        return;
    }
    
    if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition) {
        [self moveCurrentCardImageFromIndex:self.currentIndex
                                      shift:self.gifObject.items.count
                               withDuration:self.animationDuration
                            animationOption:UIImageViewAnimationOptionLinear
                        withCompletionBlock:NULL];
        
    } else if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinear) {
        [self changeImageToIndex:(self.currentIndex + 1) withTimeInterval:self.animationDuration repeat:YES];
    }
}

- (void)continueAnimating
{
    self.animationState = UIImageViewAnimationStateInPgrogress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self checkLifeCycleSanity] == NO) {
            return;
        }
        
        if ([self operationQueueIsFinished] == NO) {
            return;
        }
        
        [self moveCurrentCardImageFromIndex:self.currentIndex
                                      shift:self.gifObject.items.count
                               withDuration:self.animationDuration
                            animationOption:UIImageViewAnimationOptionLinear
                        withCompletionBlock:NULL];
    });
}

@end
