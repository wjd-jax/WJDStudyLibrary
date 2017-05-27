//
//  NSObject+JDPropertyCode.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "NSObject+JDPropertyCode.h"

@implementation NSObject (JDPropertyCode)

// 自动生成属性声明的代码
+ (void)jd_propertyCodeWithDictionary:(NSDictionary *)dict
{
    NSMutableString *strM = [NSMutableString string];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *str;
        NSLog(@"%@",[obj class]);
        
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")]||
            [obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")]||
            [obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")])
        {
            str =[NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) int %@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSArray *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSDictionary *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        }
        [strM appendFormat:@"\n%@\n",str];
        
    }];
    
    NSLog(@"%@",strM);
}

@end
