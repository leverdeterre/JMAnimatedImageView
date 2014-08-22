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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"3 GIF, 3 animations ...";
    
    if (self.memoryManagementOption == JMAnimatedImageViewMemoryLoadImageSystemCache) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"rock" withExtension:@"gif"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self.carImageView1 reloadAnimationImagesFromGifData:data];
        self.carImageView1.animationType = JMAnimatedImageViewAnimationTypeInteractive;
        
        url = [[NSBundle mainBundle] URLForResource:@"Rotating_earth" withExtension:@"gif"];
        data = [NSData dataWithContentsOfURL:url];
        [self.carImageView2 reloadAnimationImagesFromGifData:data];
        self.carImageView2.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinear;
        self.carImageView2.animationDuration = 3;
        [self.carImageView2 startAnimating];
        
        url = [[NSBundle mainBundle] URLForResource:@"nyan" withExtension:@"gif"];
        data = [NSData dataWithContentsOfURL:url];
        [self.carImageView3 reloadAnimationImagesFromGifData:data];
        self.carImageView3.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutAnimation;
        [self.carImageView3 startAnimating];
    } else {
    
        [self.carImageView1 reloadAnimationImagesFromGifNamed:@"rock"];
        self.carImageView1.animationType = JMAnimatedImageViewAnimationTypeInteractive;

        [self.carImageView2 reloadAnimationImagesFromGifNamed:@"Rotating_earth"];
        self.carImageView2.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinear;
        self.carImageView2.animationDuration = 3;
        [self.carImageView2 startAnimating];
        
        [self.carImageView3 reloadAnimationImagesFromGifNamed:@"nyan"];
        self.carImageView3.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutAnimation;
        [self.carImageView3 startAnimating];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
