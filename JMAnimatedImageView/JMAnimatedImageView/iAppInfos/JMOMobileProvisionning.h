//
//  JMOMobileProvisionning.h
//  iAppInfos
//
//  Created by Jerome Morissard on 11/21/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MobileProvisioningAppIDName @"AppIDName"
#define MobileProvisioningApplicationIdentifierPrefix @"ApplicationIdentifierPrefix"
#define MobileProvisioningCreationDate @"CreationDate"
#define MobileProvisioningEntitlements @"Entitlements"
#define MobileProvisioningExpirationDate @"ExpirationDate"
#define MobileProvisioningName @"Name"
#define MobileProvisioningProvisionedDevices @"ProvisionedDevices"
#define MobileProvisioningTeamName @"TeamName"
#define MobileProvisioningGetTaskAllow @"get-task-allow"
#define MobileProvisioningApsEnvironment @"aps-environment"

typedef NS_ENUM(NSUInteger, JMOMobileProvisionningPushConfiguration) {
    JMOMobileProvisionningPushConfigurationDisable,
    JMOMobileProvisionningPushConfigurationDevelopment,
    JMOMobileProvisionningPushConfigurationProduction
};

@interface JMOMobileProvisionning : NSObject

@property (strong, nonatomic) NSDictionary *summary;
@property (strong, nonatomic) NSString *appIDName;
@property (strong, nonatomic) NSArray *applicationIdentifierPrefix;
@property (strong, nonatomic) NSString *creationDate;
@property (strong, nonatomic) NSString *expirationDate;
@property (strong, nonatomic) NSArray *entitlements;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *provisionedDevices;
@property (strong, nonatomic) NSString *teamName;
@property (strong, nonatomic) NSString *isDevMobileProvisioning;
@property (strong, nonatomic) NSString *apsEnvironment;
@property (assign, readonly, nonatomic) JMOMobileProvisionningPushConfiguration pushConfiguration;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
