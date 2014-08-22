//
//  JMODevicePowerInfos.m
//  iAppInfos
//
//  Created by Jerome Morissard on 1/19/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//


#define jmoiPadLimitOfBadPerformaceFuturemark        2500.0f //treshold base on realScore (futuremark)
#define jmoiPadLimitOfBadPerformaceGeekbench         400.0f //treshold base on realScore (geekBench)

#define jmoiPhoneLimitOfBadPerformaceFuturemark      200.0f //treshold base on realScore (futuremark)
#define jmoiPhoneLimitOfBadPerformaceGeekbench       100.0f //treshold base on realScore (geekBench)

#define jmoUndefinedScore -1

#import "JMODevicePowerInfos.h"
#import "UIDevice+iAppInfos.h"
#import "JMOLogMacro.h"

@implementation JMODevicePowerInfos

- (instancetype)init
{
    self = [super init];
    if (self) {
        _futuremarkScore = jmoUndefinedScore;
        _geekbenchScore = jmoUndefinedScore;
        _retina = (BOOL)([UIScreen mainScreen].scale == 2.0f);
    }
    
    return self;
}

+ (instancetype)infosForDeviceModelNamed:(NSString *)deviceModelName
{
    JMODevicePowerInfos *infos = [[JMODevicePowerInfos alloc] init];
    infos.deviceModel = deviceModelName;
    
    if ([deviceModelName isEqualToString:UIDeviceModeliPodTouch1G] ) {
        infos.systemOnChip = @"Samsung S5L8900";
        infos.cpu = @"ARM1176JZ(F)-S v1.0";
        infos.gpu = @"PowerVR MBX Lite";
        infos.futuremarkScore = 120;
        infos.geekbenchScore = 75;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPhone1G] ) {
        infos.systemOnChip = @"Samsung S5L8900";
        infos.cpu = @"ARM1176JZ(F)-S v1.0";
        infos.gpu = @"PowerVR MBX Lite";
        infos.futuremarkScore = 120;
        infos.geekbenchScore = 75;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPhone3G] ) {
        infos.systemOnChip = @"Samsung S5L8720";
        infos.gpu = @"PowerVR MBX Lite";
        infos.futuremarkScore = 120; //in theory iphone 3GS is 2.5% faster
        infos.geekbenchScore = 75;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPodTouch2G] ) {
        infos.systemOnChip = @"Samsung S5L8720";
        infos.cpu = @"ARM1176JZ(F)-S v1.0";
        infos.gpu = @"PowerVR MBX Lite";
        infos.futuremarkScore = 120;
        infos.geekbenchScore = 75;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPhone3GS] ) {
        infos.systemOnChip = @"Samsung S5PC100";
        infos.cpu = @"ARM Cortex-A8";
        infos.gpu = @"PowerVR SGX535";
        infos.futuremarkScore = 300; //in theory iphone 4 is 35% faster
        infos.geekbenchScore = 149;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPodTouch3G] ) {
        infos.systemOnChip = @"Samsung S5PC100";
        infos.cpu = @"ARM Cortex-A8";
        infos.gpu = @"PowerVR SGX535";
        infos.futuremarkScore = 300;
        infos.geekbenchScore = 149;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPad]) {
        infos.systemOnChip = @"Apple A4";
        infos.cpu = @"ARM Cortex-A8";
        infos.gpu = @"PowerVR SGX535";
        infos.futuremarkScore = 1434; //in theory ipad2/2
        infos.geekbenchScore = 200;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPhone4] ||
             [deviceModelName isEqualToString:UIDeviceModelVerizoniPhone4] ) {
        infos.systemOnChip = @"Apple A4";
        infos.cpu = @"ARM Cortex-A8";
        infos.gpu = @"PowerVR SGX535";
        infos.futuremarkScore = 488;
        infos.geekbenchScore = 210;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPodTouch4G] ) {
        infos.systemOnChip = @"Apple A4";
        infos.cpu = @"ARM Cortex-A8";
        infos.gpu = @"PowerVR SGX535";
        infos.futuremarkScore = 488;
        infos.geekbenchScore = 209;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPad2_Wifi] ||
             [deviceModelName isEqualToString:UIDeviceModeliPad2_GSM]  ||
             [deviceModelName isEqualToString:UIDeviceModeliPad2_CDMA] ||
             [deviceModelName isEqualToString:UIDeviceModeliPad2]) {
        infos.systemOnChip = @"Apple A5";
        infos.cpu = @"ARM Cortex-A9";
        infos.gpu = @"PowerVR SGX543MP2";
        infos.futuremarkScore = 2868;
        infos.geekbenchScore = 490;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPhone4S] ) {
        infos.systemOnChip = @"Apple A5";
        infos.cpu = @"ARM Cortex-A9";
        infos.gpu = @"PowerVR SGX543MP2";
        infos.futuremarkScore = 2330;
        infos.geekbenchScore = 406;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPad3G_Wifi] ||
             [deviceModelName isEqualToString:UIDeviceModeliPad3G_4G]  ||
             [deviceModelName isEqualToString:UIDeviceModeliPad3G_4G]) {
        //http://community.futuremark.com/hardware/mobile/Apple+iPad+3/review
        infos.systemOnChip = @"Apple A5";
        infos.cpu = @"Apple A5X";
        infos.gpu = @"PowerVR SGX543MP4";
        infos.futuremarkScore = 4209;
        infos.geekbenchScore = 493;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPhone5_GSM] ||
             [deviceModelName isEqualToString:UIDeviceModeliPhone5_GSM_CDMA] ) {
        infos.systemOnChip = @"Apple A6";
        infos.cpu = @"Swift (Apple-designed)";
        infos.gpu = @"PowerVR SGX543MP3";
        infos.futuremarkScore = 5689;
        infos.geekbenchScore = 1279;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPodTouch5G] ) {
        infos.systemOnChip = @"Apple A5";
        infos.cpu = @"ARM Cortex-A9";
        infos.gpu = @"PowerVR SGX543MP2";
        infos.futuremarkScore = 2316;
        infos.geekbenchScore = 410;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPad4G_Wifi] ||
             [deviceModelName isEqualToString:UIDeviceModeliPad4G_GSM]  ||
             [deviceModelName isEqualToString:UIDeviceModeliPad4G_GSM_CDMA]) {
        infos.systemOnChip = @"Apple A6X";
        infos.cpu = @"Swift (Apple-designed)";
        infos.gpu = @"PowerVR SGX554MP4";
        infos.futuremarkScore = 9615;
        infos.geekbenchScore = 1409;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPadMini1G_Wifi] ||
             [deviceModelName isEqualToString:UIDeviceModeliPadMini1G_GSM]  ||
             [deviceModelName isEqualToString:UIDeviceModeliPadMini1G_GSM_CDMA]) {
        infos.systemOnChip = @"Apple A5";
        infos.cpu = @"ARM Cortex-A9";
        infos.gpu = @"PowerVR SGX543MP2";
        infos.futuremarkScore = 2847;
        infos.geekbenchScore = 492;
        infos.retina = NO;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPhone5C_GSM] ||
             [deviceModelName isEqualToString:UIDeviceModeliPhone5C_Global] ) {
        infos.systemOnChip = @"Apple A6";
        infos.cpu = @"Swift (Apple-designed)";
        infos.gpu = @"PowerVR SGX543MP3";
        infos.futuremarkScore = 5851;
        infos.geekbenchScore = 1248;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPhone5S_GSM] ||
             [deviceModelName isEqualToString:UIDeviceModeliPhone5S_Global] ) {
        infos.systemOnChip = @"Apple A7";
        infos.cpu = @"Cyclone (Apple-designed)";
        infos.gpu = @"PowerVR G6430";
        infos.futuremarkScore = 9615*2; //in theory ipad4*2
        infos.geekbenchScore = 2488;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPadMiniRetina2G_Wifi] ||
             [deviceModelName isEqualToString:UIDeviceModeliPadMiniRetina2G_Cellular] ) {
        infos.systemOnChip = @"Apple A7";
        infos.cpu = @"Cyclone (Apple-designed)";
        infos.gpu = @"PowerVR G6430";
        infos.futuremarkScore = 9615*2; //in theory ipad4*2
        infos.geekbenchScore = 2390;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPadAir_Wifi] ||
             [deviceModelName isEqualToString:UIDeviceModeliPadAir_Cellular] ) {
        infos.systemOnChip = @"Apple A7";
        infos.cpu = @"Cyclone (Apple-designed)";
        infos.gpu = @"PowerVR G6430";
        infos.futuremarkScore = 9615*2; //in theory ipad4*2
        infos.geekbenchScore = 2594;
        infos.retina = YES;
    }
    
    else if ([deviceModelName isEqualToString:UIDeviceModeliPadAir_4GCellular]) {
        infos.systemOnChip = @"Apple A7";
        infos.cpu = @"Cyclone (Apple-designed)";
        infos.gpu = @"PowerVR G6430";
        infos.futuremarkScore = 9615*2; //in theory == UIDeviceModeliPadAir_Wifi
        infos.geekbenchScore = 2594;
        infos.retina = YES;
    }
    else if ([deviceModelName isEqualToString:UIDeviceModeliPadMiniRetina4G_Cellular] ) {
        infos.systemOnChip = @"Apple A7";
        infos.cpu = @"Cyclone (Apple-designed)";
        infos.gpu = @"PowerVR G6430";
        infos.futuremarkScore = 9615*2; //in theory == UIDeviceModeliPadAir_Wifi
        infos.geekbenchScore = 2390;
        infos.retina = YES;
    }
    
    return infos;
}

- (BOOL)hasGoodGraphicPerformance
{
    //Return YES for hasGoodGraphicPerformance for unknow device (new devices are suppose to be better ...)
    if (self.futuremarkScore == jmoUndefinedScore || self.geekbenchScore == jmoUndefinedScore ) {
        return YES;
    }
    
    if ([self.deviceModel rangeOfString:@"Simulator"].location != NSNotFound) {
        return YES;
    }
    else if ([self.deviceModel rangeOfString:@"iPad"].location != NSNotFound) {
        if ([self realScore] < jmoiPadLimitOfBadPerformaceGeekbench) {
            return NO;
        }
    }
    else if ([self.deviceModel rangeOfString:@"iPhone"].location != NSNotFound) {
        if ([self realScore] < jmoiPadLimitOfBadPerformaceGeekbench) {
            return NO;
        }
    }
    else if ([self.deviceModel rangeOfString:@"iPod"].location != NSNotFound) {
        if ([self realScore] < jmoiPadLimitOfBadPerformaceGeekbench) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -

- (CGFloat)realScore
{
    return [self geekbenchScoreCorrected];
}

- (CGFloat)futuremarkScoreCorrected
{
    CGFloat retinaCost = 2.0f;
    if (self.retina) {
        return ((CGFloat)self.futuremarkScore/retinaCost);
    }
    return (CGFloat)self.futuremarkScore;
}

- (CGFloat)geekbenchScoreCorrected
{
    CGFloat retinaCost = 2.0f;
    if (self.retina) {
        return ((CGFloat)self.self.geekbenchScore/retinaCost);
    }
    return (CGFloat)self.self.geekbenchScore;
}

#pragma mark -

+ (void)sortAlldevices
{
    //IPADS
    JMOLog(@"IPADS ");
    
    NSArray *alliPadDevices = @[UIDeviceModeliPad,UIDeviceModeliPad2_Wifi,UIDeviceModeliPad3G_Wifi,UIDeviceModeliPad4G_Wifi,UIDeviceModeliPadMini1G_Wifi,UIDeviceModeliPadMiniRetina2G_Wifi,UIDeviceModeliPadAir_Wifi];
    NSMutableArray *arrayOfDeviceInfos = [NSMutableArray new];
    for (NSString *deviceName in alliPadDevices) {
        [arrayOfDeviceInfos addObject:[self.class infosForDeviceModelNamed:deviceName]];
    }
    
    NSArray *iPadSorted = [arrayOfDeviceInfos sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(JMODevicePowerInfos *obj1, JMODevicePowerInfos *obj2) {
        if ([obj1 realScore] > [obj2 realScore] ) {
            return NSOrderedAscending;
        }
        else if ([obj2 realScore] > [obj1 realScore] ) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    
    int i = 1;
    for (JMODevicePowerInfos *info in iPadSorted) {
        NSLog(@"%d\t%@ %f",i, info.deviceModel, [info realScore]);
        i++;
    }
    
    //IPHONES
    JMOLog(@"IPHONES ");
    
    NSArray *alliPhoneDevices = @[UIDeviceModeliPhone1G,UIDeviceModeliPhone3G, UIDeviceModeliPhone3GS,UIDeviceModeliPhone4,UIDeviceModeliPhone4S, UIDeviceModeliPhone5_GSM,UIDeviceModeliPhone5C_GSM,UIDeviceModeliPhone5S_GSM ];
    arrayOfDeviceInfos = [NSMutableArray new];
    for (NSString *deviceName in alliPhoneDevices) {
        [arrayOfDeviceInfos addObject:[self.class infosForDeviceModelNamed:deviceName]];
    }
    
    NSArray *iphoneSorted = [arrayOfDeviceInfos sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(JMODevicePowerInfos *obj1, JMODevicePowerInfos *obj2) {
        if ([obj1 realScore] > [obj2 realScore] ) {
            return NSOrderedAscending;
        }
        else if ([obj2 realScore] > [obj1 realScore] ) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    
    i = 1;
    for (JMODevicePowerInfos *info in iphoneSorted) {
        NSLog(@"%d\t%@ %f",i, info.deviceModel, [info realScore]);
        i++;
    }
    
}

@end
