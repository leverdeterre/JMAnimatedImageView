//
//  JMViewController.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMViewController.h"
#import "JMAnimatedImageView.h"
#import "JMAnimatedGifImageView.h"

@interface JMViewController () <JMOImageViewAnimationDelegate, JMOImageViewAnimationDatasource>
@property (weak, nonatomic) IBOutlet JMAnimatedImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) JMAnimatedImageViewAnimationType animationType;
@end

@implementation JMViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (self.demoExemple & JMDemoAutomatic) {
        if (self.demoExemple & JMDemoChangeImageSwipeTransition) {
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinear;

        } else {
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
        }
        
    }
    
    if (self.demoExemple & JMDemoInteractive) {
        self.carImageView.animationType = JMAnimatedImageViewAnimationTypeInteractive;
        
        if (self.demoExemple & JMDemoChangeImageSwipeTransition) {
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeManualSwipe;
        }
    }
    
    if (self.demoExemple & JMDemoMemoryBySystem) {
        self.carImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageSystemCache;
    
    } else {
        self.carImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;

    }
    
    if (self.demoExemple & JMDemoReverseImage) {
        self.carImageView.imageOrder = JMAnimatedImageViewOrderReverse;
    }
    
    self.imageView.hidden = YES;
    self.carImageView.hidden = NO;
    self.carImageView.animationDelegate = self;
    self.carImageView.animationDatasource = self;
    self.carImageView.animationRepeatCount = 0;
    self.carImageView.animationDuration = 4.0;
    
    if (self.demoExemple & JMDemoAutomatic) {
        [self.carImageView startAnimating];
    } else {
        [self.carImageView setCurrentIndex:0 animated:NO];
    }
}

#pragma mark - JMOImageViewAnimationDatasource

- (NSInteger)numberOfImagesForAnimatedImageView:(UIImageView *)imageView
{
    if (self.demoExemple & JMDemoPhotos) {
        return 11;
    }
    return 70;
}

- (NSString *)imageNameAtIndex:(NSInteger)index forAnimatedImageView:(UIImageView *)imageView
{
    if (self.demoExemple & JMDemoPhotos) {
        return [NSString stringWithFormat:@"%d_verge_super_wide.jpg",(int)index];
    }
    
    return [NSString stringWithFormat:@"zoom_1920_%d.jpg",(int)index];
}

- (NSInteger)firstIndexForAnimatedImageView:(UIImageView *)imageView
{
    if (self.demoExemple & JMDemoPhotos) {
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
