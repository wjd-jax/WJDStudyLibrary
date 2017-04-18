//
//  JDTimeFomatTool.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/17.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 时间格式转换@"yyyyMMddHHmmss"
 */
@interface JDTimeFormatTool : NSObject

+ (NSDate *)coverToDateWith:(NSString *)timeString format:(NSString *)formatString;
+ (NSString *)coverToDateWithDate:(NSDate *)timeDate format:(NSString *)formatString;
+ (NSString *)coverToTimeFormatStringWithFormatingSting:(NSString *)formatSting WithTimeSting:(NSString *)timeSting andCurrerntFormat:(NSString *)oldFormatSting;
@end
