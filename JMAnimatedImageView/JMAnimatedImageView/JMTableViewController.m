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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    JMAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.ramVc.view removeFromSuperview];
    [self.view addSubview:appDelegate.ramVc.view];
    [appDelegate.ramVc startRefreshingMemoryUsage];
    
    CGRect rect = appDelegate.ramVc.view.frame;
    rect.origin.x = 800;
    appDelegate.ramVc.view.frame = rect;
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
        vc.demoExemple = JMDemoAutomaticAnimationUsingImageViewImageAndSystemCache;
        
    } else if (indexPath.row == 1) {
        vc.demoExemple = JMDemoAutomaticAnimationUsingJMAnimatedImageViewImageAndSystemCache;

    } else if (indexPath.row == 2) {
        vc.demoExemple = JMDemoAutomaticAnimationUsingJMAnimatedImageViewImageAndWithoutCache;
        
    } else if (indexPath.row == 3) {
        vc.demoExemple = JMDemoAutoSwipeAnimationUsingJMAnimatedImageViewImageAndWithoutCache;
        
    } else if (indexPath.row == 4) {
        vc.demoExemple = JMDemoInteractiveAnimationUsingJMAnimatedImageViewImageAndWithoutCache;

    } else if (indexPath.row == 5) {
        vc.demoExemple = JMDemoCarouselUsingJMAnimatedImageViewImageAndWithoutCache;

    } else if (indexPath.row == 6) {
        vc.demoExemple = JMDemoGIFAutomaticAnimationUsingImageViewImageAndSystemCache;

    } else if (indexPath.row == 7) {
        vc.demoExemple = JMDemoGIFInteractiveAnimationUsingImageViewImageAndSystemCache;

    } else if (indexPath.row == 8) {
        vc.demoExemple = JMDemoGIFMultipleAnimationUsingImageViewImageAndSystemCache;
        
    }

    [self.navigationController pushViewController:vcToPush animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
