//
//  JMViewController.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMViewController.h"
#import "JMAnimatedImageView.h"

@interface JMViewController () <JMOImageViewAnimationDelegate, JMOImageViewAnimationDatasource>
@property (weak, nonatomic) IBOutlet JMAnimatedImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation JMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.useJMImageView == NO) {
        self.imageView.hidden = NO;
        self.carImageView.hidden = YES;

        NSMutableArray *images = [NSMutableArray new];
        for (int i = 0; i < [self numberOfImagesForAnimatedImageView:self.carImageView]; i++) {
            [images addObject:[UIImage imageNamed:[self imageNameAtIndex:i forAnimatedImageView:self.carImageView]]];
        }
        
        self.imageView.animationImages = images;
        self.imageView.animationRepeatCount = 0;
        self.imageView.animationDuration = 4.0;
        [self.imageView startAnimating];
        
    } else {
        self.imageView.hidden = YES;
        self.carImageView.hidden = NO;
        
        if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
            self.carImageView.contentMode = UIViewContentModeCenter; //photos a not well sized
        }
        
        self.carImageView.animationDelegate = self;
        self.carImageView.animationDatasource = self;
        self.carImageView.animationType = self.animationType;
        self.carImageView.memoryManagementOption = self.memoryManagementOption;
        self.carImageView.imageOrder = self.order;
        [self.carImageView reloadAnimationImages];
        
        if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinear) {
            self.carImageView.animationRepeatCount = 0;
            self.carImageView.animationDuration = 5.0;
            [self.carImageView startAnimating];
        }
    }
}

#pragma mark - JMOImageViewAnimationDatasource

- (NSInteger)numberOfImagesForAnimatedImageView:(UIImageView *)imageView
{
    if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
        return 11;
    }
    return 70;
}

- (NSString *)imageNameAtIndex:(NSInteger)index forAnimatedImageView:(UIImageView *)imageView
{
    if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
        return [NSString stringWithFormat:@"%d_verge_super_wide.jpg",(int)index];
    }
    
    return [NSString stringWithFormat:@"zoom_1920_%d.jpg",(int)index];
}

- (NSInteger)firstIndexForAnimatedImageView:(UIImageView *)imageView
{
    if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
        return 0;
    }
    
    return 0;
}

@end
