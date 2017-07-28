//
//  JDUserDefault.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDUserDefault : NSObject

/**
 快速设置UserDefault

 @param value id
 @param key key
 */
+ (void)setValue:(nonnull id)value forKey:(nonnull NSString *)key;

+ (nonnull id)valueForKey:(nonnull NSString *)key;

@end
