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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
        cell.jmLabel.text = @"REALTIME ANIMATION : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"Swipe left / Right to manage the animation.";
        
    } else if (indexPath.row == 4) {
        cell.jmLabel.text = @"SIMPLE CAROUSEL : using JMAnimatedImageView (Low memory usage)";
        cell.jmDetailsLabel.text = @"Swipe left / Right";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JMViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"JMViewController"];
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
        vc.animationType = JMAnimatedImageViewAnimationTypeManualRealTime;
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageLowMemoryUsage;
        vc.order = JMAnimatedImageViewOrderReverse;
        vc.useJMImageView = YES;
    } else if (indexPath.row == 4) {
        vc.animationType = JMAnimatedImageViewAnimationTypeManualSwipe;
        vc.memoryManagementOption = JMAnimatedImageViewMemoryLoadImageSystemCache;
        vc.order = JMAnimatedImageViewOrderReverse;
        vc.useJMImageView = YES;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
