//
//  UIApplication+iAppInfos.m
//  iAppInfos
//
//  Created by Jerome Morissard on 11/21/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import "UIApplication+iAppInfos.h"
#import <Availability.h>

@implementation UIApplication (iAppInfos)

+ (NSString *)jmo_iOSSDKVersion
{
#if defined(__IPHONE_8_0)
    return @"SDK8.0 (Xcode6.0)";
#elif defined(__IPHONE_7_1)
    return @"SDK7.1 (Xcode5.1)";
#elif defined(__IPHONE_7_0)
//#warning "SDK7"
    return @"SDK7.0 (Xcode5)";
#elif defined(__IPHONE_6_1)
//#warning "SDK6.1"
    return @"SDK6.1 (Xcode4)";
#elif defined(__IPHONE_5_1)
//#warning "SDK5.1"
    return @"SDK5.1 (Xcode4)";
#else
//#warning "SDK<5"
    return @"SDK<5.1 (Xcode?)";
#endif
}


@end
