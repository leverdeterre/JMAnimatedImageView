//
//  JMFLViewController.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 21/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMFLViewController.h"
#import "JMAnimatedImageView.h"

@interface JMFLViewController ()
@property (weak, nonatomic) IBOutlet JMAnimatedImageView *carImageView1;
@property (weak, nonatomic) IBOutlet JMAnimatedImageView *carImageView2;
@property (weak, nonatomic) IBOutlet JMAnimatedImageView *carImageView3;
@end

@implementation JMFLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"3 GIF, 3 animations ...";

    self.carImageView1.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
    [self.carImageView1 reloadAnimationImagesFromGifNamed:@"rock"];

    self.carImageView2.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
    [self.carImageView2 reloadAnimationImagesFromGifNamed:@"Rotating_earth"];

    self.carImageView3.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
    [self.carImageView3 reloadAnimationImagesFromGifNamed:@"nyan"];

    if (self.demoExemple & JMDemoInteractive) {
        self.carImageView1.animationType = JMAnimatedImageViewAnimationTypeInteractive;
        self.carImageView2.animationType = JMAnimatedImageViewAnimationTypeInteractive;
        self.carImageView3.animationType = JMAnimatedImageViewAnimationTypeInteractive;
        [self.carImageView1 setInteractiveAnimation:YES];
        [self.carImageView2 setInteractiveAnimation:YES];
        [self.carImageView3 setInteractiveAnimation:YES];
        
    } else {
        self.carImageView1.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
        self.carImageView2.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
        self.carImageView3.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
        [self.carImageView1 setInteractiveAnimation:NO];
        [self.carImageView2 setInteractiveAnimation:NO];
        [self.carImageView3 setInteractiveAnimation:NO];
        
        self.carImageView1.animationDuration = 3;
        self.carImageView2.animationDuration = 3;
        self.carImageView3.animationDuration = 3;

        [self.carImageView1 startAnimating];
        [self.carImageView2 startAnimating];
        [self.carImageView3 startAnimating];
    }
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
