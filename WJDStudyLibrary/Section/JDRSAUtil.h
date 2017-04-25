//
//  JDRSAUtil.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDRSAUtil : NSObject

/**
 公钥加密

 @param str 需要加密的字符串
 @param pubKey 公钥
 @return 加密后的字符串(base64编码)
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;


/**
 私钥解密(公钥或者私钥)
 
 @param str 需要解密的字符串
 @param privKey 私钥
 @return 解密后的字符串
 */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;


/**
 私钥签名

 @param str 需要签名的字符串
 @param privKey 私钥
 @return 签名过的字符串
 */
+ (NSString *)signatureString:(NSString *)str privateKey:(NSString *)privKey;

/**
 公钥验证签名

 @param str 签名后的字符串
 @param pubKey 公钥
 @return 解密后的原文(需要跟自己的原文进行比较从而验证是否是私钥进行的签名)
 */
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;

@end
