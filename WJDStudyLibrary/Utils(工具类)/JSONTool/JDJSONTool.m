//
//  JDJSONTool.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/10/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDJSONTool.h"

@implementation JDJSONTool

+ (NSData *)covertToDataWithDict:(NSDictionary *)dic
{
    NSString *string = [self dictionaryToJson:dic];
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}
+ (NSDictionary *)covertToDictWithData:(NSData *)data
{
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
    return [self dictionaryWithJsonString:result];
}
//对象转dict
+ (NSDictionary*)coverToDictionaryFromObject:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
     
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self coverToDictionaryFromObject:obj];
}

+(NSString *)coverToJsonStringFromObject:(id)obj
{
    NSDictionary *dic =[self coverToDictionaryFromObject:obj];
    return [self dictionaryToJson:dic];
}

#pragma mark json字符串转化为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    if (dic) {
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    else return nil;
    
}


@end
