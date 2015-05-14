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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JMTableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.jmLabel.text = @"PNG + Automatic Transition + system cache";
            cell.jmDetailsLabel.text = @"All images are loaded in one time in memory (so ... it's take a lot of time to run the 1st time).";
            break;
            
        case 1:
            cell.jmLabel.text = @"PNG + Automatic Transition + system cache";
            cell.jmDetailsLabel.text = @"Images are loaded during the animation.";
            break;
            
        case 2:
            cell.jmLabel.text = @"PNG + Automatic Transition + JMAnimatedImageView cache";
            cell.jmDetailsLabel.text = @"More CPU time to load / reload images but less memory used.";
            break;
            
        case 3:
            cell.jmLabel.text = @"PNG + Interactive Transition + JMAnimatedImageView cache";
            cell.jmDetailsLabel.text = @"Swipe left / Right to manage the animation.";
            break;
            
        case 4:
            cell.jmLabel.text = @"PNG + Carousel Transition + JMAnimatedImageView cache";
            cell.jmDetailsLabel.text = @"Swipe left / Right to swipe";
            break;

        case 5:
            cell.jmLabel.text = @"GIF + Automatic Transition + JMAnimatedImageView cache";
            cell.jmDetailsLabel.text = @"Swipe left / Right";
            break;
            
        case 6:
            cell.jmLabel.text = @"GIF + Interactive Transition + JMAnimatedImageView cache";
            cell.jmDetailsLabel.text = @"Swipe left / Right";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    JMDemoType demoType = 0;
    switch (indexPath.row) {
        case 0:
            demoType = ( JMDemoAutomatic | JMDemoMemoryBySystem | JMDemoChangeImageNoTransition);
            break;
            
        case 1:
            demoType = ( JMDemoAutomatic | JMDemoMemoryBySystem | JMDemoChangeImageNoTransition);
            break;
            
        case 2:
            demoType = ( JMDemoAutomatic | JMDemoMemoryByMyComponent | JMDemoChangeImageNoTransition);
            break;
            
        case 3:
            demoType = ( JMDemoInteractive | JMDemoMemoryByMyComponent | JMDemoChangeImageNoTransition | JMDemoReverseImage);
            break;
            
        case 4:
            demoType = ( JMDemoInteractive | JMDemoMemoryByMyComponent | JMDemoChangeImageSwipeTransition | JMDemoPhotos);
            break;
          
        case 5:
            demoType = ( JMDemoAutomatic | JMDemoMemoryByMyComponent | JMDemoChangeImageNoTransition);
            break;
           
        case 6:
            demoType = ( JMDemoInteractive | JMDemoMemoryByMyComponent | JMDemoChangeImageNoTransition);
            break;
            
        default:
            break;
    }

    if (indexPath.row > 4) {
        JMFLViewController *vc = [JMFLViewController new];
        UIViewController *vcToPush = vc;
        vc.demoExemple = demoType;
        [self.navigationController pushViewController:vcToPush animated:YES];
        
    } else {
        JMViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"JMViewController"];
        UIViewController *vcToPush = vc;
        vc.demoExemple = demoType;
        [self.navigationController pushViewController:vcToPush animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

@end
