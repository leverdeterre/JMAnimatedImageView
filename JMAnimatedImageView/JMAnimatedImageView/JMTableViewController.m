//
//  JMTableViewController.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 15/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMTableViewController.h"
#import "JMViewController.h"
#import "JMTableViewCell.h"
#import "JMFLViewController.h"
#import "JMAppDelegate.h"

@interface JMTableViewController ()

@end

@implementation JMTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"JMAnimatedImageView demos";
    JMAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate loadMemoryFollower];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    JMAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.ramVc.view removeFromSuperview];
    
    [self.view addSubview:appDelegate.ramVc.view];
    [appDelegate.ramVc startRefreshingMemoryUsage];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.jmLabel.text = @"AUTOMATIC ANIMATION : using UIImageView";
        cell.jmDetailsLabel.text = @"All images are loaded in one time in memory (so ... it's take a lot of time to run the 1st time).";
        
    } else if (indexPath.row == 1) {
        cell.jmLabel.text = @"AUTOMATIC ANIMATION : using JMAnimatedImageView (using Sytem cache)";
        cell.jmDetailsLabel.text = @"Images are loaded during the animation.";

    } else if (indexPath.row == 2) {
        cell.jmLabel.text = @"AUTOMATIC ANIMATION : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"More CPU time to load / reload images but less memory used.";
        
    } else if (indexPath.row == 3) {
        cell.jmLabel.text = @"AUTOMATIC ANIMATION : using JMAnimatedImageView with transition";
        cell.jmDetailsLabel.text = @"More CPU time to load / reload images but less memory used.";
        
    } else if (indexPath.row == 4) {
        cell.jmLabel.text = @"REALTIME ANIMATION : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"Swipe left / Right to manage the animation.";
        
    } else if (indexPath.row == 5) {
        cell.jmLabel.text = @"SIMPLE CAROUSEL : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"Swipe left / Right";
        
    } else if (indexPath.row == 6) {
        cell.jmLabel.text = @"GIF ANIMATION : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"Swipe left / Right";
        
    } else if (indexPath.row == 7) {
        cell.jmLabel.text = @"GIF INTERACTION : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"Swipe left / Right";
        
    } else if (indexPath.row == 8) {
        cell.jmLabel.text = @"MULTIPLE GIF ANIMATIONS : using JMAnimatedImageView";
        cell.jmDetailsLabel.text = @"";
    }
    
    else if (indexPath.row == 9) {
        cell.jmLabel.text = @"MULTIPLE GIF ANIMATIONS : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JMViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"JMViewController"];
    UIViewController *vcToPush = vc;
    
    if (indexPath.row == 0) {
        vc.useJMImageView = NO;
        
    } else if (indexPath.row == 1) {
        vc.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutAnimation;
        vc.useJMImageView = YES;

    } else if (indexPath.row == 2) {
        vc.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutAnimation;
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
        vc.useJMImageView = YES;
    } else if (indexPath.row == 3) {
        vc.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinear;
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
        vc.useJMImageView = YES;
        
    } else if (indexPath.row == 4) {
        vc.animationType = JMAnimatedImageViewAnimationTypeInteractive;
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
        vc.order = JMAnimatedImageViewOrderReverse;
        vc.useJMImageView = YES;
        
    } else if (indexPath.row == 5) {
        vc.animationType = JMAnimatedImageViewAnimationTypeManualSwipe;
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageSystemCache;
        vc.order = JMAnimatedImageViewOrderReverse;
        vc.useJMImageView = YES;
        
    } else if (indexPath.row == 6) {
        vc.animationType = JMAnimatedImageViewAnimationTypeAutomaticLinearWithoutAnimation /*JMAnimatedImageViewAnimationTypeManualRealTime*/;
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
        vc.useJMImageView = YES;
        vc.usingGif = YES;
        vc.order = JMAnimatedImageViewOrderNormal;

    } else if (indexPath.row == 7) {
        vc.animationType =  JMAnimatedImageViewAnimationTypeInteractive;
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
        vc.useJMImageView = YES;
        vc.usingGif = YES;
        vc.order = JMAnimatedImageViewOrderNormal;
        
    } else if (indexPath.row == 8) {
        JMFLViewController *vc = [JMFLViewController new];
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageSystemCache;
        vcToPush = vc;
        
    } else if (indexPath.row == 9) {
        JMFLViewController *vc = [JMFLViewController new];
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
        vcToPush = vc;
    }
    
    [self.navigationController pushViewController:vcToPush animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
