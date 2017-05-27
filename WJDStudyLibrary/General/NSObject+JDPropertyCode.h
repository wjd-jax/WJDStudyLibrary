//
//  NSObject+JDPropertyCode.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 自动生成属性
 */
@interface NSObject (JDPropertyCode)

/**
 自动生成属性申明的 Code
 
 @param dict 传入的属性字典
 */
+ (void)jd_propertyCodeWithDictionary:(NSDictionary *)dict;

@end
