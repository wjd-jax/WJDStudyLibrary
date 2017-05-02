//
//  JDRSAUtil.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/pem.h>
#import <openssl/rsa.h>
typedef void (^keyPair)(SecKeyRef publicKey ,SecKeyRef privateKey);

@interface JDRSAUtil : NSObject

/**
 公钥加密

 @param str 需要加密的字符串
 @param pubKey 公钥key字符串
 @return 加密后的字符串(base64编码)
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;


/**
 私钥解密(公钥或者私钥)
 
 @param str 需要解密的字符串
 @param privKey 私钥key字符串
 @return 解密后的字符串
 */
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;


/**
 私钥签名

 @param str 需要签名的字符串
 @param privKey 私钥key字符串
 @return 签名过的字符串
 */
+ (NSString *)signatureString:(NSString *)str privateKey:(NSString *)privKey;

/**
 公钥验证签名

 @param str 签名后的字符串
 @param pubKey 公钥key字符串
 @return 解密后的原文(需要跟自己的原文进行比较从而验证是否是私钥进行的签名)
 */
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;


/**
 苹果自带类获取密钥对

 @param keySize 密钥对长度512/1024/2048
 @param pair 返回的公钥对
 */
+ (void)getRSAKeyPairWithKeySize:(int)keySize keyPair:(keyPair)pair;

+ (BOOL)generateRSAKeyPairWithKeySize:(int)keySize publicKey:(RSA **)publicKey privateKey:(RSA **)privateKey;

/**
 将 RSA 类型的 key 转化为 Pem 格式的字符串

 @param rsaKey 公钥或者私钥
 @param isPublickey 是否是公钥标志
 @return pem 格式的字符串
 */
+ (NSString *)PEMFormatRSAKey:(RSA *)rsaKey isPublic:(BOOL)isPublickey;


//公钥加密
#pragma mark -  密钥对 Data 加密
+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef isSign:(BOOL)isSign;
+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef;
#pragma mark -openSSL方式加密解密
+ (NSData *)encryptWithRSA:(RSA *)rasKey plainData:(NSData *)plainData isPublicKey:(BOOL)isPubulic ;
+ (NSData *)decryptWithRSAKey:(RSA *)rsaKey cipherData:(NSData *)cipherData :(BOOL)isPubulic;

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key;
+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key;


@end
