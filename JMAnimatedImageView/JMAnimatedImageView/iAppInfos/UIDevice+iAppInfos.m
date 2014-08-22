//
//  UIDevice+iAppInfos.m
//  iAppInfos
//
//  Created by Jerome Morissard on 11/21/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import "UIDevice+iAppInfos.h"
#import "JMODevicePowerInfos.h"

#include <sys/sysctl.h>

NSString * const UIDeviceModeliPhone1G                      = @"iPhone 1G";
NSString * const UIDeviceModeliPhone3G                      = @"iPhone 3G";
NSString * const UIDeviceModeliPhone3GS                     = @"iPhone 3GS";

NSString * const UIDeviceModeliPhone4                       = @"iPhone 4";
NSString * const UIDeviceModelVerizoniPhone4                = @"Verizon iPhone 4";
NSString * const UIDeviceModeliPhone4S                      = @"iPhone 4S";

NSString * const UIDeviceModeliPhone5_GSM                   = @"iPhone 5 (GSM)";
NSString * const UIDeviceModeliPhone5_GSM_CDMA              = @"iPhone 5 (GSM+CDMA)";
NSString * const UIDeviceModeliPhone5C_GSM                  = @"iPhone 5C (GSM)";
NSString * const UIDeviceModeliPhone5C_Global               = @"iPhone 5C (Global)";

NSString * const UIDeviceModeliPhone5S_GSM                  = @"iPhone 5S (GSM)";
NSString * const UIDeviceModeliPhone5S_Global               = @"iPhone 5S (Global)";

NSString * const UIDeviceModeliPodTouch1G                   = @"iPod Touch 1G";
NSString * const UIDeviceModeliPodTouch2G                   = @"iPod Touch 2G";
NSString * const UIDeviceModeliPodTouch3G                   = @"iPod Touch 3G";
NSString * const UIDeviceModeliPodTouch4G                   = @"iPod Touch 4G";
NSString * const UIDeviceModeliPodTouch5G                   = @"iPod Touch 5G";

NSString * const UIDeviceModeliPad                          = @"iPad";
NSString * const UIDeviceModeliPad2_Wifi                    = @"iPad 2 (WiFi)";
NSString * const UIDeviceModeliPad2_GSM                     = @"iPad 2 (GSM)";
NSString * const UIDeviceModeliPad2_CDMA                    = @"iPad 2 (CDMA)";
NSString * const UIDeviceModeliPad2                         = @"iPad 2";
NSString * const UIDeviceModeliPad3G_Wifi                   = @"iPad-3G (WiFi)";
NSString * const UIDeviceModeliPad3G_4G                     = @"iPad-3G (4G)";
NSString * const UIDeviceModeliPad4G_Wifi                   = @"iPad-4G (WiFi)";
NSString * const UIDeviceModeliPad4G_GSM                    = @"iPad-4G (GSM)";
NSString * const UIDeviceModeliPad4G_GSM_CDMA               = @"iPad-4G (GSM+CDMA)";

NSString * const UIDeviceModeliPadMini1G_Wifi               = @"iPad mini-1G (WiFi)";
NSString * const UIDeviceModeliPadMini1G_GSM                = @"iPad mini-1G (GSM)";
NSString * const UIDeviceModeliPadMini1G_GSM_CDMA           = @"iPad mini-1G (GSM+CDMA)";
NSString * const UIDeviceModeliPadMiniRetina2G_Wifi         = @"iPad mini 2G Retina (WiFi)";
NSString * const UIDeviceModeliPadMiniRetina2G_Cellular     = @"iPad mini 2G Retina (Cellular)";
NSString * const UIDeviceModeliPadAir_Wifi                  = @"iPad Air (WiFi)";
NSString * const UIDeviceModeliPadAir_Cellular              = @"iPad Air (Cellular)";
NSString * const UIDeviceModeliPadAir_4GCellular            = @"iPad Air (4G)";
NSString * const UIDeviceModeliPadMiniRetina4G_Cellular     = @"iPad mini (4G)";

NSString * const UIDeviceModelSimulatorI386                 = @"iPhone Simulator (i386)";
NSString * const UIDeviceModelSimulatorX86_64               = @"iPhone Simulator (x86_64)";
NSString * const UIDeviceModelSimulator                     = @"iPhone Simulator";


@implementation UIDevice (iAppInfos)

+ (NSString *) jmo_getSysInfo
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

+ (NSString *)jmo_modelName
{
    NSString *systInfo = [self jmo_getSysInfo];
    if ([systInfo isEqualToString:@"iPhone1,1"])    return UIDeviceModeliPhone1G;
    if ([systInfo isEqualToString:@"iPhone1,2"])    return UIDeviceModeliPhone3G;
    if ([systInfo isEqualToString:@"iPhone2,1"])    return UIDeviceModeliPhone3GS;
    if ([systInfo isEqualToString:@"iPhone3,1"])    return UIDeviceModeliPhone4;
    if ([systInfo isEqualToString:@"iPhone3,3"])    return UIDeviceModelVerizoniPhone4;
    if ([systInfo isEqualToString:@"iPhone4,1"])    return UIDeviceModeliPhone4S;
    if ([systInfo isEqualToString:@"iPhone5,1"])    return UIDeviceModeliPhone5_GSM;
    if ([systInfo isEqualToString:@"iPhone5,2"])    return UIDeviceModeliPhone5_GSM_CDMA;
    if ([systInfo isEqualToString:@"iPhone5,3"])    return UIDeviceModeliPhone5C_GSM;
    if ([systInfo isEqualToString:@"iPhone5,4"])    return UIDeviceModeliPhone5C_Global;
    if ([systInfo isEqualToString:@"iPhone6,1"])    return UIDeviceModeliPhone5S_GSM;
    if ([systInfo isEqualToString:@"iPhone6,2"])    return UIDeviceModeliPhone5S_Global;
    if ([systInfo isEqualToString:@"iPod1,1"])      return UIDeviceModeliPodTouch1G;
    if ([systInfo isEqualToString:@"iPod2,1"])      return UIDeviceModeliPodTouch2G;
    if ([systInfo isEqualToString:@"iPod3,1"])      return UIDeviceModeliPodTouch3G;
    if ([systInfo isEqualToString:@"iPod4,1"])      return UIDeviceModeliPodTouch4G;
    if ([systInfo isEqualToString:@"iPod5,1"])      return UIDeviceModeliPodTouch5G;
    if ([systInfo isEqualToString:@"iPad1,1"])      return UIDeviceModeliPad;
    if ([systInfo isEqualToString:@"iPad2,1"])      return UIDeviceModeliPad2_Wifi;
    if ([systInfo isEqualToString:@"iPad2,2"])      return UIDeviceModeliPad2_GSM;
    if ([systInfo isEqualToString:@"iPad2,3"])      return UIDeviceModeliPad2_CDMA;
    if ([systInfo isEqualToString:@"iPad2,4"])      return UIDeviceModeliPad2;
    if ([systInfo isEqualToString:@"iPad3,1"])      return UIDeviceModeliPad3G_Wifi;
    if ([systInfo isEqualToString:@"iPad3,2"])      return UIDeviceModeliPad3G_4G;
    if ([systInfo isEqualToString:@"iPad3,3"])      return UIDeviceModeliPad3G_4G;
    if ([systInfo isEqualToString:@"iPad3,4"])      return UIDeviceModeliPad4G_Wifi;
    if ([systInfo isEqualToString:@"iPad3,5"])      return UIDeviceModeliPad4G_GSM;
    if ([systInfo isEqualToString:@"iPad3,6"])      return UIDeviceModeliPad4G_GSM_CDMA;
    if ([systInfo isEqualToString:@"iPad2,5"])      return UIDeviceModeliPadMini1G_Wifi;
    if ([systInfo isEqualToString:@"iPad2,6"])      return UIDeviceModeliPadMini1G_GSM;
    if ([systInfo isEqualToString:@"iPad2,7"])      return UIDeviceModeliPadMini1G_GSM_CDMA;
    if ([systInfo isEqualToString:@"iPad4,4"])      return UIDeviceModeliPadMiniRetina2G_Wifi;
    if ([systInfo isEqualToString:@"iPad4,5"])      return UIDeviceModeliPadMiniRetina2G_Cellular;
    if ([systInfo isEqualToString:@"iPad4,1"])      return UIDeviceModeliPadAir_Wifi;
    if ([systInfo isEqualToString:@"iPad4,2"])      return UIDeviceModeliPadAir_Cellular;
    if ([systInfo isEqualToString:@"iPad4,3"])      return UIDeviceModeliPadAir_4GCellular;
    if ([systInfo isEqualToString:@"iPad4,6"])      return UIDeviceModeliPadMiniRetina4G_Cellular;
    if ([systInfo isEqualToString:@"i386"])         return UIDeviceModelSimulator;
    if ([systInfo isEqualToString:@"x86_64"])       return UIDeviceModelSimulator;
    
    return systInfo;
}


+ (UIDeviceModelType)jmo_deviceModelType {
    NSString *modelName = [self jmo_modelName];

    if ([modelName rangeOfString:@"iPhone"].location != NSNotFound) {
        return UIDeviceModelTypeiPhone;
    }
    else if ([modelName rangeOfString:@"iPod"].location != NSNotFound) {
        return UIDeviceModelTypeiPod;
    }
    else if ([modelName rangeOfString:@"iPad"].location != NSNotFound) {
        return UIDeviceModelTypeiPad;
    }
    
    return UIDeviceModelTypeSimulator;
}

+ (JMODevicePowerInfos *)jmo_devicePowerInfos
{
    return [JMODevicePowerInfos infosForDeviceModelNamed:[self jmo_modelName]];
}

@end
