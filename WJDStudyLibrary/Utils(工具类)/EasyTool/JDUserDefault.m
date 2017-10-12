//
//  JDUserDefault.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDUserDefault.h"
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

@implementation JDUserDefault


+ (void)setValue:(id)value forKey:(nonnull NSString *)key{
    
    [USER_DEFAULT setValue:value forKey:key];
    [USER_DEFAULT synchronize];
}

+ (id)valueForKey:(nonnull NSString *)key{
    
   return [USER_DEFAULT objectForKey:key];
}

@end
