//
//  NSDictionary+iAppInfos.m
//  iAppInfos
//
//  Created by Jerome Morissard on 11/21/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import "NSDictionary+iAppInfos.h"
#import "JMOMobileProvisionning.h"

@implementation NSDictionary (MobileProvisionningParser)

+ (NSDictionary *)jmo_dictionaryWithDefaultMobileProvisioning
{
    // There is no provisioning profile in AppStore Apps
    NSString *profilePath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    NSString *result = nil;
    
    // Check provisioning profile existence
    if (profilePath)
    {
        // Get hex representation
        NSData *profileData = [NSData dataWithContentsOfFile:profilePath];
        NSString *profileString = [NSString stringWithFormat:@"%@", profileData];
        
        // Remove brackets at beginning and end
        profileString = [profileString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
        profileString = [profileString stringByReplacingCharactersInRange:NSMakeRange(profileString.length - 1, 1) withString:@""];
        
        // Remove spaces
        profileString = [profileString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        // Convert hex values to readable characters
        NSMutableString *profileText = [NSMutableString new];
        for (int i = 0; i < profileString.length; i += 2)
        {
            NSString *hexChar = [profileString substringWithRange:NSMakeRange(i, 2)];
            int value = 0;
            sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
            [profileText appendFormat:@"%c", (char)value];
        }
        
        NSRange range1 = [profileText rangeOfString:@"<?xml"];
        if ( range1.location != NSNotFound ) {
            NSRange range2 = [profileText rangeOfString:@"</plist>"];
            if ( range2.location != NSNotFound ) {
                NSRange range = NSMakeRange(range1.location, range2.location + range2.length - range1.location);
                result = [profileText substringWithRange:range];
                
                NSDictionary *dict = [NSDictionary jmo_dictionaryWithMobileProvisioningString:result];
                return dict;
            }
        }
        
    }
    
    return nil;
}

+ (NSDictionary *)jmo_dictionaryWithMobileProvisioningString:(NSString *)RawMobileProvisionning
{
    NSMutableDictionary *dictionary =  [NSMutableDictionary new];
    NSArray* lines = [RawMobileProvisionning componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];

    for (int i = 0; i < lines.count; i++) {
        NSString *line = [lines objectAtIndex:i];
        if ([self lineString:line containsKey:MobileProvisioningAppIDName]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSString *appIDName = [self extractStringValueInLine:nextLine];
            if (appIDName.length > 0) {
                [dictionary setObject:appIDName forKey:MobileProvisioningAppIDName];
                continue;
            }
        }
        
        if ([self lineString:line containsKey:MobileProvisioningApplicationIdentifierPrefix]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSMutableArray *arryOfApplicationIdentifierPrefix = [NSMutableArray new];
            while ([nextLine rangeOfString:@"</array>"].location == NSNotFound) {
                NSString *value = [self extractStringValueInLine:nextLine];
                if (value.length > 0) {
                    [arryOfApplicationIdentifierPrefix addObject:value];
                }
                i++;
                nextLine = [lines objectAtIndex:i];
            }
            
            [dictionary setObject:arryOfApplicationIdentifierPrefix forKey:MobileProvisioningApplicationIdentifierPrefix];
        }

        if ([self lineString:line containsKey:MobileProvisioningCreationDate]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSString *creationDate = [self extractDateValueInLine:nextLine];
            if (nil != creationDate) {
                [dictionary setObject:creationDate forKey:MobileProvisioningCreationDate];
                continue;
            }
        }
        
        if ([self lineString:line containsKey:MobileProvisioningExpirationDate]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSString *creationDate = [self extractDateValueInLine:nextLine];
            if (nil != creationDate) {
                [dictionary setObject:creationDate forKey:MobileProvisioningExpirationDate];
                continue;
            }
        }
        
        if ([self lineString:line containsKey:MobileProvisioningName]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSString *name = [self extractStringValueInLine:nextLine];
            if (nil != name) {
                [dictionary setObject:name forKey:MobileProvisioningName];
                continue;
            }
        }
        
        if ([self lineString:line containsKey:MobileProvisioningProvisionedDevices]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSMutableArray *arryOfProvisionedDevices = [NSMutableArray new];
            while ([nextLine rangeOfString:@"</array>"].location == NSNotFound) {
                NSString *value = [self extractStringValueInLine:nextLine];
                if (value.length > 0) {
                    [arryOfProvisionedDevices addObject:value];
                }
                
                i++;
                nextLine = [lines objectAtIndex:i];
            }
            
            [dictionary setObject:arryOfProvisionedDevices forKey:MobileProvisioningProvisionedDevices];
            continue;
        }
        
        if ([self lineString:line containsKey:MobileProvisioningTeamName]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSString *creationDate = [self extractStringValueInLine:nextLine];
            if (nil != creationDate) {
                [dictionary setObject:creationDate forKey:MobileProvisioningTeamName];
                continue;
            }
        }
        
        if ([self lineString:line containsKey:MobileProvisioningGetTaskAllow]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSString *isDevMobileProvisioning = [self extractBoolValueInLine:nextLine];
            if (nil != isDevMobileProvisioning) {
                [dictionary setObject:isDevMobileProvisioning forKey:MobileProvisioningGetTaskAllow];
                continue;
            }
        }
        
        if ([self lineString:line containsKey:MobileProvisioningApsEnvironment]) {
            NSString *nextLine = [lines objectAtIndex:i+1];
            NSString *apsEnv = [self extractStringValueInLine:nextLine];
            if (nil != apsEnv) {
                [dictionary setObject:apsEnv forKey:MobileProvisioningApsEnvironment];
                continue;
            }

        }
    }
    
    return dictionary;
}

+ (BOOL)lineString:(NSString *)line containsKey:(NSString *)key
{
    if ([line rangeOfString:[NSString stringWithFormat:@"<key>%@</key>", key]].location != NSNotFound) {
        return YES;
    }
    return NO;
}

+ (NSString *)extractStringValueInLine:(NSString *)line
{
    NSRange rangeStart = [line rangeOfString:@"<string>"];
    NSRange rangeEnd = [line rangeOfString:@"</string>"];
    if (rangeStart.location != NSNotFound && rangeEnd.location != NSNotFound ) {
        return [line substringWithRange:NSMakeRange(rangeStart.location+rangeStart.length, rangeEnd.location - (rangeStart.location+rangeStart.length) )];
    }
    
    return @"";
}

+ (NSString *)extractDateValueInLine:(NSString *)line
{
    NSRange rangeStart = [line rangeOfString:@"<date>"];
    NSRange rangeEnd = [line rangeOfString:@"</date>"];
    if (rangeStart.location != NSNotFound && rangeEnd.location != NSNotFound ) {
        return [line substringWithRange:NSMakeRange(rangeStart.location+rangeStart.length, rangeEnd.location - (rangeStart.location+rangeStart.length) )];
    }
    
    return @"";
}

+ (NSString *)extractBoolValueInLine:(NSString *)line
{
    NSRange rangeTrue = [line rangeOfString:@"true"];
    if (rangeTrue.location != NSNotFound ) {
        return @"true";
    }
    
    return @"false";
}


@end
