//
//  ZBTool.h
//  HTTPTransfer
//
//  Created by 柏超曾 on 2017/8/28.
//  Copyright © 2017年 柏超曾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBTool : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (BOOL)isValidatIP:(NSString *)ipAddress ;

+ (NSDictionary *)getIPAddresses;
@end
