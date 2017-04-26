//
//  JDKeyPairViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDKeyPairViewController.h"
#import <openssl/rsa.h>
#import <openssl/pem.h>
#import <openssl/bio.h>

static const UInt8 publicKeyIdentifier[] = "com.apple.sample.publickey/0";
static const UInt8 privateKeyIdentifier[] = "com.apple.sample.privatekey/0";

@interface JDKeyPairViewController ()

@end

@implementation JDKeyPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createKeyPair];
    [self generateKeyPairPlease];
    // Do any additional setup after loading the view.
}
- (void)createKeyPair {
    
# ifndef OPENSSL_NO_DEPRECATED
    RSA *RSA_generate_key(int bits, unsigned long e, void
                          (*callback) (int, int, void *), void *cb_arg);
# endif                         /* !defined(OPENSSL_NO_DEPRECATED) */
    
    /* New version */
    int RSA_generate_key_ex(RSA *rsa, int bits, BIGNUM *e, BN_GENCB *cb);
    //提取公钥、私钥
    RSA *RSAPublicKey_dup(RSA *rsa);
    RSA *RSAPrivateKey_dup(RSA *rsa);
    
    //
}

//- (NSString *)PEMFormatPublicKey:(RSA *)rsaPublic
//{
//    BIO *bio = BIO_new(BIO_s_mem());
//    PEM_write_bio_RSA_PUBKEY(bio, rsaPublic);
//
//    BUF_MEM *bptr;
//    BIO_get_mem_ptr(bio, &bptr);
//    BIO_set_close(bio, BIO_NOCLOSE); /* So BIO_free() leaves BUF_MEM alone */
//    BIO_free(bio);
//
//    return [NSString stringWithUTF8String:bptr->data];
//}

- (void)generateKeyPairPlease
{
    OSStatus status = noErr;
    
    //定义dictionary，用于传递SecKeyGeneratePair函数中的第1个参数。
    NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
   
    //把第1步中定义的字符串转换为NSData对象。
    NSData * publicTag = [NSData dataWithBytes:publicKeyIdentifier
                                        length:strlen((const char *)publicKeyIdentifier)];
    NSData * privateTag = [NSData dataWithBytes:privateKeyIdentifier
                                         length:strlen((const char *)privateKeyIdentifier)];
    //为公／私钥对准备SecKeyRef对象。
    SecKeyRef publicKey = NULL;
    SecKeyRef privateKey = NULL;
    
    //设置密钥对的密钥类型为RSA。
    [keyPairAttr setObject:(id)kSecAttrKeyTypeRSA forKey:(id)kSecAttrKeyType];
    //设置密钥对的密钥长度为1024。
    [keyPairAttr setObject:[NSNumber numberWithInt:1024] forKey:(id)kSecAttrKeySizeInBits];
    
    //设置私钥的持久化属性（即是否存入钥匙串）为YES。
    [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecAttrIsPermanent];
    [privateKeyAttr setObject:privateTag forKey:(id)kSecAttrApplicationTag];
    
    //设置公钥的持久化属性（即是否存入钥匙串）为YES。
    [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(id)kSecAttrIsPermanent];
    [publicKeyAttr setObject:publicTag forKey:(id)kSecAttrApplicationTag];
    
    // 把私钥的属性集（dictionary）加到密钥对的属性集（dictionary）中。
    [keyPairAttr setObject:privateKeyAttr forKey:(id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(id)kSecPublicKeyAttrs];
    
    //生成密钥对
    status = SecKeyGeneratePair((CFDictionaryRef)keyPairAttr,&publicKey, &privateKey); // 13
    if (status == noErr && publicKey != NULL && privateKey != NULL) {
        
        DLog(@"%@\n%@",publicKey,privateKey);
        
    }
}

@end
