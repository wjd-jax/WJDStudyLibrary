//
//  JDDeviceUtils.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/11/7.
//  Copyright © 2017年 wangjundong. All rights reserved.
//  获取手机型号信息

#import "JDDeviceUtils.h"
#import <sys/utsname.h>

@implementation JDDeviceUtils

+ (DeviceType)deviceType{
    
   
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine
                                                encoding:NSUTF8StringEncoding];
        //simulator
        if ([platform isEqualToString:@"i386"])          return Simulator;
        if ([platform isEqualToString:@"x86_64"])        return Simulator;
        
        //iPhone
        if ([platform isEqualToString:@"iPhone1,1"])     return IPhone_1G;
        if ([platform isEqualToString:@"iPhone1,2"])     return IPhone_3G;
        if ([platform isEqualToString:@"iPhone2,1"])     return IPhone_3GS;
        if ([platform isEqualToString:@"iPhone3,1"])     return IPhone_4;
        if ([platform isEqualToString:@"iPhone3,2"])     return IPhone_4;
        if ([platform isEqualToString:@"iPhone4,1"])     return IPhone_4s;
        if ([platform isEqualToString:@"iPhone5,1"])     return IPhone_5;
        if ([platform isEqualToString:@"iPhone5,2"])     return IPhone_5;
        if ([platform isEqualToString:@"iPhone5,3"])     return IPhone_5C;
        if ([platform isEqualToString:@"iPhone5,4"])     return IPhone_5C;
        if ([platform isEqualToString:@"iPhone6,1"])     return IPhone_5S;
        if ([platform isEqualToString:@"iPhone6,2"])     return IPhone_5S;
        if ([platform isEqualToString:@"iPhone7,1"])     return IPhone_6P;
        if ([platform isEqualToString:@"iPhone7,2"])     return IPhone_6;
        if ([platform isEqualToString:@"iPhone8,1"])     return IPhone_6s;
        if ([platform isEqualToString:@"iPhone8,2"])     return IPhone_6s_P;
        if ([platform isEqualToString:@"iPhone8,4"])     return IPhone_SE;
        if ([platform isEqualToString:@"iPhone9,1"])     return IPhone_7;
        if ([platform isEqualToString:@"iPhone9,3"])     return IPhone_7;
        if ([platform isEqualToString:@"iPhone9,2"])     return IPhone_7P;
        if ([platform isEqualToString:@"iPhone9,4"])     return IPhone_7P;
        if ([platform isEqualToString:@"iPhone10,1"])    return IPhone_8;
        if ([platform isEqualToString:@"iPhone10,4"])    return IPhone_8;
        if ([platform isEqualToString:@"iPhone10,2"])    return IPhone_8P;
        if ([platform isEqualToString:@"iPhone10,5"])    return IPhone_8P;
        if ([platform isEqualToString:@"iPhone10,3"])    return IPhone_X;
        if ([platform isEqualToString:@"iPhone10,6"])    return IPhone_X;
    
        return Unknown;
    
}

@end
