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
        
        if (self.usingGif == NO) {
            [self.carImageView reloadAnimationImages];
            
        } else {
            [self.carImageView reloadAnimationImagesFromGifNamed:@"rock"];
        }
        
        if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutAnimation) {
            self.carImageView.animationRepeatCount = 0;
            if (self.usingGif) {
                self.carImageView.animationDuration = JMDefaultGifDuration; //GIF DURATION IS A PART OF THE GIF DATA
            } else {
                self.carImageView.animationDuration = 5.0; //GLOBAL TIME OF ANIMATION
            }
            
            [self.carImageView startAnimating];
        } else if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinear) {
            self.carImageView.animationRepeatCount = 0;
            self.carImageView.animationDuration = 2.0; //ONE TRANSITION TIME
            [self.carImageView startAnimating];
        }
    }
    
    [self updateTitle];
}

- (void)updateTitle
{
    if (self.useJMImageView == NO) {
        self.title = @"using UIImageView class";
    } else {
        if (self.animationType == JMAnimatedImageViewAnimationTypeManualSwipe) {
            self.title = @"using JMImageView class has a simple carousel";
        } else if (self.animationType == JMAnimatedImageViewAnimationTypeInteractive) {
            if (self.memoryManagementOption == JMAnimatedImageViewMemoryLoadImageSystemCache) {
                self.title = @"using JMImageView class to animate in real time (500Mo ...)";
            } else {
                self.title = @"using JMImageView class to animate in real time (30Mo ^_^)";
            }
            
        } else if (self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinear ||
                   self.animationType == JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutAnimation) {
            
            if (self.memoryManagementOption == JMAnimatedImageViewMemoryLoadImageSystemCache) {
                self.title = @"using JMImageView class for automatic animation (500Mo ...)";
            } else {
                self.title = @"using JMImageView class for automatic animation (30Mo ^_^)";
            }
        } else if ( self.usingGif) {
            self.title = @"using GIF with JMImageView class";
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

- (void)dealloc
{
    [self.carImageView stopAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    JMAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.ramVc.view removeFromSuperview];
    
    [self.view addSubview:appDelegate.ramVc.view];
    [appDelegate.ramVc startRefreshingMemoryUsage];
}

@end
