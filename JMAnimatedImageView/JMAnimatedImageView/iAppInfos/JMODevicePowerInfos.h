//
//  JMODevicePowerInfos.h
//  iAppInfos
//
//  Created by Jerome Morissard on 1/19/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMODevicePowerInfos : NSObject

@property (strong, nonatomic) NSString *systemOnChip;
@property (strong, nonatomic) NSString *deviceModel;
@property (strong, nonatomic) NSString *cpu;
@property (strong, nonatomic) NSString *gpu;
@property (assign, nonatomic) NSUInteger futuremarkScore;   //http://community.futuremark.com/hardware/mobile/
@property (assign, nonatomic) NSUInteger geekbenchScore;    //http://browser.primatelabs.com/ios-benchmarks
@property (assign, nonatomic) BOOL retina;
@property (assign, nonatomic, getter = hasGoodGraphicPerformance) BOOL goodPerformance;

+ (instancetype)infosForDeviceModelNamed:(NSString *)deviceModelName;
+ (void)sortAlldevices;
- (BOOL)hasGoodGraphicPerformance;

@end