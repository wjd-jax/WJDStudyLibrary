//
//  JDJSONTool.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/10/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDJSONTool : NSObject

//对象转化为json字符串
+(NSString *)coverToJsonStringFromObject:(id)obj;
//对象转化为字典(忽略属性说明,因为安卓没做好,临时添加的处理)
+ (NSDictionary*)coverToDictionaryFromObject:(id)obj;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSData *)covertToDataWithDict:(NSDictionary *)dic;

+ (NSDictionary *)covertToDictWithData:(NSData *)data;

@end
