//
//  JMRamViewController.m
//  JMAnimatedImageView
//
//  Created by jerome morissard on 22/08/14.
//  Copyright (c) 2014 jerome morissard. All rights reserved.
//

#import "JMRamViewController.h"
#import "AppInformationsManager.h"
#import "mach/mach.h"

@interface JMRamViewController ()
@property (weak, nonatomic) IBOutlet UILabel *memoryLabel;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) CGFloat initailFreeMemorySpaceMo;
@end

@implementation JMRamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //_initailFreeMemorySpaceMo = [self getUsedMemory];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)refreshMemoryUsage
{
    self.memoryLabel.text = [NSString stringWithFormat:@"%2.f MO",[self getUsedMemory]];
}

- (CGFloat)getUsedMemory
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t) &info, &size);
    if (kerr == KERN_SUCCESS) {
        CGFloat freeMemorySpaceMo = info.resident_size / (1024 * 1024);
        return freeMemorySpaceMo;
    }
    
    /*
    NSInteger pourcentFreeMemorySpace = [[AppInformationsManager sharedManager] freeMemorySpace];
    unsigned long long totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    NSProcessInfo *info = [NSProcessInfo processInfo];
    CGFloat freeMemorySpaceMo = ((CGFloat)pourcentFreeMemorySpace/100.0f) * (totalMemory/(1024*1024));
    return freeMemorySpaceMo; */
    return -1.0f;

}

- (void)startRefreshingMemoryUsage
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshMemoryUsage) userInfo:nil repeats:YES];
    [self.timer fire];
}

@end
