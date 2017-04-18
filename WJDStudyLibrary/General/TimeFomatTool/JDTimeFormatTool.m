//
//  JDTimeFomatTool.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/17.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDTimeFormatTool.h"

@implementation JDTimeFormatTool

+ (NSDate *)coverToDateWith:(NSString *)timeString format:(NSString *)formatString
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //  设置日期格式----@"yyyyMMddHHmmss"
    [formatter setDateFormat:formatString];
    //  根据指定格式的字符串获取NSDate
    NSDate *date = [formatter dateFromString:timeString];
    
    return date;
    
}
+ (NSString *)coverToDateWithDate:(NSDate *)timeDate format:(NSString *)formatString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    //  将NSDate转换成指定格式的字符串
    NSString *currentDateStr = [formatter stringFromDate:timeDate];
    return currentDateStr;
}

+ (NSString *)coverToTimeFormatStringWithFormatingSting:(NSString *)formatSting WithTimeSting:(NSString *)timeSting andCurrerntFormat:(NSString *)oldFormatSting
{
    NSDate *date  =[self  coverToDateWith:timeSting format:oldFormatSting];
    return [self coverToDateWithDate:date format:formatSting];
    
}
@end
