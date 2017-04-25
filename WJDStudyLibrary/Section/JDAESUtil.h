//
//  JDAESUtil.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDAESUtil : NSObject

/**
 AES 加密

 @param content 需要加密的原文
 @param key 密码
 @return base64编码后的密文
 */
+ (NSString *)encrypt:(NSString *)content password:(NSString *)key;

/**
 AES 解密

 @param base64Content base64编码后的密文
 @param key 密钥
 @return 原文
 */
+ (NSString *)decrypt:(NSString *)base64Content password:(NSString *)key;

@end
