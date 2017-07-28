//
//  JDAESUtil.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDAESUtil.h"
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>

NSString *const kInitVector = @"16-Bytes--String";
size_t const kKeySize = kCCKeySizeAES128;

@implementation JDAESUtil

+ (NSString *)encrypt:(NSString *)content password:(NSString *)key{
   
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    
    // 为结束符'\\0' +1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  //系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
}

+ (NSString *)decrypt:(NSString *)base64Content password:(NSString *)key{
    
    //把 base64 String 转换成 Data
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:base64Content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength = contentData.length;

    char keyPtr[kKeySize+1];
    memset(keyPtr,0,sizeof(keyPtr));
    
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    size_t decryptSize = dataLength +kCCBlockSizeAES128;
    void *decryptedBytes= malloc(decryptSize);
    
    
    size_t actualOutSize =0;
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    
    CCCryptorStatus cryptStatus =
    CCCrypt(kCCDecrypt,
            kCCAlgorithmAES,
            kCCOptionPKCS7Padding,
            keyPtr,
            kKeySize,
            initVector.bytes,
            contentData.bytes,
            dataLength,
            decryptedBytes,
            decryptSize,
            &actualOutSize);
    
    if(cryptStatus==kCCSuccess)
    {
        return [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
    }
    free(decryptedBytes);
    return nil;
    
}

@end
