//
//  AppInformationsManager.m
//  iAppInfos
//
//  Created by Jerome Morissard on 11/21/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import "AppInformationsManager.h"

#import "UIApplication+iAppInfos.h"
#import "NSDictionary+iAppInfos.h"
#import "JMODevicePowerInfos.h"

#import "mach/mach.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface AppInformationsManager ()
@property (strong, nonatomic) NSMutableDictionary *customValues;
@end

@implementation AppInformationsManager

#define MB (1024*1024)
#define GB (MB*1024)

#pragma mark Singleton Methods

+ (instancetype)sharedManager
{
    static AppInformationsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _customValues = [NSMutableDictionary new];
    }
    return self;
}

- (NSString *)description
{
    NSArray *keys = [self filteredKeys];
    NSMutableString *str = [NSMutableString new];
    [str appendString:@"\n"];
    
    JMOMobileProvisionning *mobileProvi = nil;
    [str appendFormat:@"\n\t#Global infos\n"];
    for (NSString *key in keys) {
        id info = [[AppInformationsManager sharedManager] infoForKey:key];
        if ([key isEqualToString:AppVersionManagerKeyMobileProvisionning]) {
             mobileProvi = (JMOMobileProvisionning *)info;
        }
        else {
            [str appendFormat:@"\t\t%@\t%@\n", key, info];
        }
    }
    
    if (nil != mobileProvi) {
        [str appendFormat:@"\n\t#MobileProvisionning infos\n"];
        [str appendFormat:@"\t\t%@\n", mobileProvi.teamName ];
        [str appendFormat:@"\t\t%@\n", mobileProvi];
    }
    
    return str;
}

#pragma overrided getters

- (NSString *)targetedVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleInfoDictionaryVersion"];
}

- (NSString *)currentOSVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *)shortAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSInteger)freeMemorySpace
{
    unsigned long freeSpace = machFreeMemory();
    unsigned long long totalMemory = [[NSProcessInfo processInfo] physicalMemory];
    CGFloat pourcent = (CGFloat)freeSpace/totalMemory;
    return (NSInteger)(100*pourcent);
}

- (NSString *)operatorName
{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    return [carrier carrierName];
}

- (NSString *)deviceModelName
{
    return [UIDevice jmo_modelName];
}

- (UIDeviceModelType)deviceModelType
{
    return [UIDevice jmo_deviceModelType];
}

- (JMODevicePowerInfos *)devicePowerInfo
{
    return [UIDevice jmo_devicePowerInfos];
}

- (NSString *)compilationSDK
{
    return [UIApplication jmo_iOSSDKVersion];
}

- (NSString *)freeDiskSpace
{
    long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    return [self.class memoryFormatter:freeSpace];
}

- (NSInteger)batteryLevel
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return (NSInteger)([UIDevice currentDevice].batteryLevel * 100.0f);
}

- (JMOMobileProvisionning *)mobileProvisionning
{
    NSDictionary *dict = [NSDictionary jmo_dictionaryWithDefaultMobileProvisioning];
    if (nil == dict) {
        return nil;
    }
    
    JMOMobileProvisionning *provisionningObj = [[JMOMobileProvisionning alloc] initWithDictionary:dict];
    return provisionningObj;
}

- (NSArray *)filteredKeys
{
    if (nil == _filteredKeys) {
            return @[AppVersionManagerKeyTargetedVersion,AppVersionManagerKeyYouriOSVersion,AppVersionManagerKeyYourDeviceModel,AppVersionManagerKeyCompilationSDK, AppVersionManagerKeyCFBundleVersion, AppVersionManagerKeyCFBundleShortVersionString, AppVersionManagerKeyFreeDiskSpace,AppVersionManagerKeyFreeMemory, AppVersionManagerKeyBatteryLevel,AppVersionManagerKeyMobileProvisionning, AppVersionManagerKeyPushToken,AppVersionManagerKeyWSConfiguration];
    }
    return _filteredKeys;
}

#pragma mark - Private methods
#pragma mark *memory

+ (NSString *)memoryFormatter:(long long)diskSpace {
    NSString *formatted;
    double bytes = 1.0 * diskSpace;
    double megabytes = bytes / MB;
    double gigabytes = bytes / GB;
    if (gigabytes >= 1.0)
        formatted = [NSString stringWithFormat:@"%.2f GB", gigabytes];
    else if (megabytes >= 1.0)
        formatted = [NSString stringWithFormat:@"%.2f MB", megabytes];
    else
        formatted = [NSString stringWithFormat:@"%.2f bytes", bytes];
    
    return formatted;
}

vm_size_t machFreeMemory(void)
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

#pragma mark - Public 

/*
 #define AppVersionManagerKeyYourDeviceType              @"deviceModelType"
 #define AppVersionManagerKeyGraphicalPerformance        @"devicePowerInfo"
 #define AppVersionManagerKeyFreeDiskSpace               @"freeDiskSpace"
 #define AppVersionManagerKeyBatteryLevel                @"batteryLevel"
 #define AppVersionManagerKeyMobileProvisionning         @"mobileProvisionning"
 */

- (id)infoForKey:(NSString *)key
{
    if ([key isEqualToString:AppVersionManagerKeyTargetedVersion]) {
        return [self targetedVersion];
    }
    else if ([key isEqualToString:AppVersionManagerKeyYouriOSVersion]) {
        return [self currentOSVersion];
    }
    else if ([key isEqualToString:AppVersionManagerKeyYourDeviceModel]) {
        return [self deviceModelName];
    }
    else if ([key isEqualToString:AppVersionManagerKeyCompilationSDK]) {
        return [self compilationSDK];
    }
    /*else if ([key isEqualToString:AppVersionManagerKeyWSConfiguration]) {
        return [self wSConfiguration];
    }*/
    else if ([key isEqualToString:AppVersionManagerKeyCFBundleVersion]) {
        return [self appVersion];
    }
    else if ([key isEqualToString:AppVersionManagerKeyCFBundleShortVersionString]) {
        return [self shortAppVersion];
    }
    else if ([key isEqualToString:AppVersionManagerKeyFreeDiskSpace]) {
        return [self freeDiskSpace];
    }
    else if ([key isEqualToString:AppVersionManagerKeyBatteryLevel]) {
        int batteryLevel = (int)[self batteryLevel];
        return [NSString stringWithFormat:@"%d%%",batteryLevel];
    }
    else if ([key isEqualToString:AppVersionManagerKeyMobileProvisionning]) {
        static JMOMobileProvisionning *provisionningObj;
        if (provisionningObj == nil) {
            provisionningObj = [self mobileProvisionning];
        }
        return provisionningObj;
    }
    /*else if ([key isEqualToString:AppVersionManagerKeyPushToken]) {
        return [self pushToken];
    }*/
    else if ([key isEqualToString:AppVersionManagerKeyFreeMemory]) {
        unsigned long freeSpace = machFreeMemory();
        unsigned long long totalMemory = [[NSProcessInfo processInfo] physicalMemory];
        CGFloat pourcent = (CGFloat)freeSpace/totalMemory;
        return [NSString stringWithFormat:@"%@ (%d%%)",[self.class memoryFormatter:freeSpace],(int)(100*pourcent)];
    }
    else if ([key isEqualToString:AppVersionManagerKeyOperator]) {
        return [self operatorName];
    }
    else if ([key isEqualToString:AppVersionManagerKeyGraphicalPerformance]) {
        JMODevicePowerInfos *graphInfo = [JMODevicePowerInfos infosForDeviceModelNamed:[UIDevice jmo_modelName]];
        if ([graphInfo hasGoodGraphicPerformance]) {
            return @"YES";
        }
        return  @"NO";
    }
    else {
        id obj = [self.customValues objectForKey:key];
        if (nil != obj) {
            return obj;
        }
    }
    return @"";
}

- (void)addCustomValue:(NSString *)value forCustomKey:(NSString *)key
{
    [self.customValues setValue:value forKey:key];
}

- (NSString *)htmlDescriptionWithKeys:(NSArray *)keys
{
    NSMutableString *str = [NSMutableString new];
    [str appendString:@"<TABLE>"];
    
    for (NSString *key in keys) {
        id info = [[AppInformationsManager sharedManager] infoForKey:key];
        if ([key isEqualToString:AppVersionManagerKeyMobileProvisionning]) {
            JMOMobileProvisionning *mobileProvi = (JMOMobileProvisionning *)info;
            [str appendFormat:@"<TR><TD>%@</TD><TD>%@</TD></TR>", key, mobileProvi.teamName ];
        }
        else {
            [str appendFormat:@"<TR><TD>%@</TD><TD>%@</TD></TR>", key, info];
        }
    }
    
    [str appendString:@"</TABLE>"];
    return str;
}

@end
