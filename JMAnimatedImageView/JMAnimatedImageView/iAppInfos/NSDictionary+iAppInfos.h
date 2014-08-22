//
//  NSDictionary+iAppInfos.h
//  iAppInfos
//
//  Created by Jerome Morissard on 11/21/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (iAppInfos)

+ (NSDictionary *)jmo_dictionaryWithDefaultMobileProvisioning;
+ (NSDictionary *)jmo_dictionaryWithMobileProvisioningString:(NSString *)RawMobileProvisionning;

@end
