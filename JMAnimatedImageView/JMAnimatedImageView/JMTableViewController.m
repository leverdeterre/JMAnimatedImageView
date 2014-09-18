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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMTableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case JMDemoAutomaticAnimationUsingImageViewImageAndSystemCache:
            cell.jmLabel.text = @"AUTOMATIC ANIMATION : using UIImageView";
            cell.jmDetailsLabel.text = @"All images are loaded in one time in memory (so ... it's take a lot of time to run the 1st time).";
            break;
            
        case JMDemoAutomaticAnimationUsingJMAnimatedImageViewImageAndSystemCache:
            cell.jmLabel.text = @"AUTOMATIC ANIMATION : using JMAnimatedImageView (using Sytem cache)";
            cell.jmDetailsLabel.text = @"Images are loaded during the animation.";
            break;
            
        case JMDemoAutomaticAnimationUsingJMAnimatedImageViewImageAndWithoutCache:
            cell.jmLabel.text = @"AUTOMATIC ANIMATION : using JMAnimatedImageView (Low memory usage)";
            cell.jmDetailsLabel.text = @"More CPU time to load / reload images but less memory used.";
            break;
            
        case JMDemoAutoSwipeAnimationUsingJMAnimatedImageViewImageAndWithoutCache:
            cell.jmLabel.text = @"AUTOMATIC ANIMATION : using JMAnimatedImageView with transition";
            cell.jmDetailsLabel.text = @"More CPU time to load / reload images but less memory used.";
            break;
            
        case JMDemoInteractiveAnimationUsingJMAnimatedImageViewImageAndWithoutCache:
            cell.jmLabel.text = @"INTERACTIVE ANIMATION : using JMAnimatedImageView (Low memory usage)";
            cell.jmDetailsLabel.text = @"Swipe left / Right to manage the animation.";
            break;
            
        case JMDemoCarouselUsingJMAnimatedImageViewImageAndWithoutCache:
            cell.jmLabel.text = @"SIMPLE CAROUSEL : using JMAnimatedImageView (Low memory usage)";
            cell.jmDetailsLabel.text = @"Swipe left / Right";
            break;
            
        case JMDemoGIFAutomaticAnimationUsingImageViewImageAndSystemCache:
            cell.jmLabel.text = @"GIF ANIMATION : using JMAnimatedImageView (Low memory usage)";
            cell.jmDetailsLabel.text = @"Swipe left / Right";
            break;
            
        case JMDemoGIFInteractiveAnimationUsingImageViewImageAndSystemCache:
            cell.jmLabel.text = @"GIF INTERACTION : using JMAnimatedImageView (Low memory usage)";
            cell.jmDetailsLabel.text = @"Swipe left / Right";
            break;
            
        default:
            break;
    }
    
    /*
        cell.jmLabel.text = @"MULTIPLE GIF ANIMATIONS : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"";
    */
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (indexPath.row == JMDemoGIFAutomaticAnimationUsingImageViewImageAndSystemCache ||
        indexPath.row == JMDemoGIFInteractiveAnimationUsingImageViewImageAndSystemCache)
    {
        JMFLViewController *vc = [JMFLViewController new];
        UIViewController *vcToPush = vc;
        vc.demoExemple = indexPath.row;
        [self.navigationController pushViewController:vcToPush animated:YES];
        
    } else {
        JMViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"JMViewController"];
        UIViewController *vcToPush = vc;
        vc.demoExemple = indexPath.row;
        [self.navigationController pushViewController:vcToPush animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
