//
//  JMViewController.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMViewController.h"
#import "JMAnimatedImageView.h"
#import "JMAnimatedImageView+JMGif.h"

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
    
    switch (self.demoExemple) {
        case JMDemoAutomaticAnimationUsingImageViewImageAndSystemCache:
        {
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
        }
            break;
            
        case JMDemoAutomaticAnimationUsingJMAnimatedImageViewImageAndSystemCache:
            self.imageView.hidden = YES;
            self.carImageView.hidden = NO;
            self.carImageView.animationDelegate = self;
            self.carImageView.animationDatasource = self;
            self.carImageView.animationRepeatCount = 0;
            self.carImageView.animationDuration = 4.0;
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
            self.carImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageSystemCache;
            self.carImageView.imageOrder = JMAnimatedImageViewOrderNormal;
            
            self.animationType = self.carImageView.animationType;
            
            [self.carImageView startAnimating];
            break;
            
        case JMDemoAutomaticAnimationUsingJMAnimatedImageViewImageAndWithoutCache:
            self.imageView.hidden = YES;
            self.carImageView.hidden = NO;
            self.carImageView.animationDelegate = self;
            self.carImageView.animationDatasource = self;
            self.carImageView.animationRepeatCount = 0;
            self.carImageView.animationDuration = 4.0;
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinear;
            self.carImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
            self.carImageView.imageOrder = JMAnimatedImageViewOrderNormal;
            
            self.animationType = self.carImageView.animationType;
            
            [self.carImageView startAnimating];
            break;
            
        case JMDemoAutoSwipeAnimationUsingJMAnimatedImageViewImageAndWithoutCache:
            self.imageView.hidden = YES;
            self.carImageView.hidden = NO;
            self.carImageView.animationDelegate = self;
            self.carImageView.animationDatasource = self;
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
            self.carImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
            self.carImageView.imageOrder = JMAnimatedImageViewOrderNormal;
            self.carImageView.animationDuration = 5.0;
            self.animationType = self.carImageView.animationType;
            
            [self.carImageView startAnimating];
            break;
            
        case JMDemoInteractiveAnimationUsingJMAnimatedImageViewImageAndWithoutCache:
            self.imageView.hidden = YES;
            self.carImageView.hidden = NO;
            self.carImageView.animationDelegate = self;
            self.carImageView.animationDatasource = self;
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeInteractive;
            self.carImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
            self.carImageView.imageOrder = JMAnimatedImageViewOrderReverse;
            self.animationType = self.carImageView.animationType;
            
            [self.carImageView reloadAnimationImages];
            [self.carImageView setInteractiveAnimation:YES];
            break;
            
        case JMDemoCarouselUsingJMAnimatedImageViewImageAndWithoutCache:
            self.imageView.hidden = YES;
            self.carImageView.hidden = NO;
            self.carImageView.animationDelegate = self;
            self.carImageView.animationDatasource = self;
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeManualSwipe;
            self.carImageView.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
            self.carImageView.imageOrder = JMAnimatedImageViewOrderNormal;
            
            self.animationType = self.carImageView.animationType;

            [self.carImageView reloadAnimationImages];
            [self.carImageView setInteractiveAnimation:YES];
            break;
            
        case JMDemoGIFAutomaticAnimationUsingImageViewImageAndSystemCache:
            self.imageView.hidden = YES;
            self.carImageView.hidden = NO;
            self.carImageView.animationDelegate = self;
            self.carImageView.animationDatasource = self;
            self.carImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutTransition;
            [self.carImageView reloadAnimationImagesFromGifNamed:@"rock"];
            [self.carImageView startAnimating];
            break;
            
        case JMDemoGIFInteractiveAnimationUsingImageViewImageAndSystemCache:
            self.imageView.hidden = YES;
            self.carImageView.hidden = NO;
            break;
            
        default:
            break;
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
