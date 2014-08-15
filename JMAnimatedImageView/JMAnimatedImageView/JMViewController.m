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
@end

@implementation JMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.carImageView.animationDelegate = self;
    self.carImageView.animationDatasource = self;
    self.carImageView.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinear;
    [self.carImageView reloadAnimationImages];
    self.carImageView.animationRepeatCount = 0;
    self.carImageView.animationDuration = 5.0;
    [self.carImageView startAnimating];
}

#pragma mark - JMOImageViewAnimationDatasource

- (NSInteger)numberOfImagesForAnimatedImageView:(UIImageView *)imageView
{
    return 70;
}

- (NSString *)imageNameAtIndex:(NSInteger)index forAnimatedImageView:(UIImageView *)imageView
{
    return [NSString stringWithFormat:@"zoom_1920_%d.jpg",(int)index];
}

- (NSInteger)firstIndexForAnimatedImageView:(UIImageView *)imageView
{
    return 0;
}

@end
