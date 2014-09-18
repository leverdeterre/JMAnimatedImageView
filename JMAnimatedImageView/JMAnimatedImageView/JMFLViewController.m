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
    /*
    JMDemoGIFAutomaticAnimationUsingImageViewImageAndSystemCache,
    JMDemoGIFInteractiveAnimationUsingImageViewImageAndSystemCache,
    JMDemoGIFMultipleAnimationUsingImageViewImageAndSystemCache
    */
    
    if (self.demoExemple == JMDemoGIFAutomaticAnimationUsingImageViewImageAndSystemCache) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"rock" withExtension:@"gif"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self.carImageView1 reloadAnimationImagesFromGifData:data];
        self.carImageView1.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
        self.carImageView1.animationDuration = 3;
        [self.carImageView1 startAnimating];
        
        url = [[NSBundle mainBundle] URLForResource:@"Rotating_earth" withExtension:@"gif"];
        data = [NSData dataWithContentsOfURL:url];
        [self.carImageView2 reloadAnimationImagesFromGifData:data];
        self.carImageView2.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
        self.carImageView2.animationDuration = 3;
        [self.carImageView2 startAnimating];
        
        url = [[NSBundle mainBundle] URLForResource:@"nyan" withExtension:@"gif"];
        data = [NSData dataWithContentsOfURL:url];
        [self.carImageView3 reloadAnimationImagesFromGifData:data];
        self.carImageView3.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
        [self.carImageView3 startAnimating];
        
    } else if (self.demoExemple == JMDemoGIFInteractiveAnimationUsingImageViewImageAndSystemCache) {
    
        [self.carImageView1 reloadAnimationImagesFromGifNamed:@"rock"];
        self.carImageView1.animationType = JMAnimatedImageViewAnimationTypeNone;
        [self.carImageView1 setInteractiveAnimation:YES];

        [self.carImageView2 reloadAnimationImagesFromGifNamed:@"Rotating_earth"];
        self.carImageView2.animationType = JMAnimatedImageViewAnimationTypeNone;
        [self.carImageView2 setInteractiveAnimation:YES];

        [self.carImageView3 reloadAnimationImagesFromGifNamed:@"nyan"];
        self.carImageView3.animationType = JMAnimatedImageViewAnimationTypeNone;
        [self.carImageView3 setInteractiveAnimation:YES];
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
