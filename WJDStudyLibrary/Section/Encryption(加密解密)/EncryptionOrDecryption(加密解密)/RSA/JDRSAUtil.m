//
//  JDRSAUtil.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDRSAUtil.h"
#import <Security/Security.h>

static NSString * const pubkeyTag =@"JDRSAUtil_PubKey";
static NSString * const privateTag =@"RSAUtil_PrivKey";

@implementation JDRSAUtil

#pragma mark - Base64编码
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}
#pragma mark -  =============苹果自带方法=====================
#pragma mark - 公钥加密
+(NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey
{
    NSData *data =[JDRSAUtil encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    //NSString *s =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //base64编码
    NSString *ret =base64_encode_data(data);
    return ret;
}

+(NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey
{
    if (!data||!pubKey) {
        DLog(@"原数据或者公钥字符串为 NULL--%@--%@",data,pubKey);
        return nil;
    }
    SecKeyRef keyRef =[JDRSAUtil addPublickey:pubKey identifier:pubkeyTag];
    if (!keyRef) {
        DLog(@"公钥错误");
        return nil;
    }
    DLog(@"%@",keyRef);
    return [JDRSAUtil encryptData:data withKeyRef:keyRef isSign:NO];
}


+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    {0x30,0x0d,0x06,0x09,0x2a,0x86,0x48,0x86,0xf7,0x0d,0x01,0x01,0x01,0x05,0x00};
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

#pragma mark -  私钥解密
+(NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey
{
    NSData *data =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [JDRSAUtil decryptData:data privateKey:privKey];
    NSString *ret = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [JDRSAUtil addPrivateKey:privKey identifier:privateTag];
    if(!keyRef){
        return nil;
    }
    return [JDRSAUtil decryptData:data withKeyRef:keyRef];
}


+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key{
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}
#pragma mark - 私钥签名
+(NSString *)signatureString:(NSString *)str privateKey:(NSString *)privKey
{
    NSData *data =[JDRSAUtil encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] privateKey:privKey];
    //NSString *s =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //base64编码
    NSString *ret =base64_encode_data(data);
    return ret;
}

+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey{
    if(!data || !privKey){
        return nil;
    }
    SecKeyRef keyRef = [JDRSAUtil addPrivateKey:privKey identifier:privateTag];
    if(!keyRef){
        return nil;
    }
    return [JDRSAUtil encryptData:data withKeyRef:keyRef isSign:YES];
}

+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey{
    NSData *data = [JDRSAUtil encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] privateKey:privKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}
#pragma mark - 公钥验证
+(NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [JDRSAUtil decryptData:data publicKey:pubKey];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [JDRSAUtil addPublickey:pubKey identifier:pubkeyTag];
    
    if(!keyRef){
        return nil;
    }
    return [JDRSAUtil decryptData:data withKeyRef:keyRef];
}
#pragma mark - 向 keyChain 中添加密钥

+ (SecKeyRef)addPrivateKey:(NSString *)key identifier:(NSString *)identifier{
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [JDRSAUtil stripPrivateKeyHeader:data];
    if(!data){
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = identifier;
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)
     kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

//向 keychain 中添加公钥
+ (SecKeyRef)addPublickey:(NSString *)key identifier:(NSString *)identifier
{
    NSRange spos =[key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if (spos.location !=NSNotFound && epos.location != NSNotFound) {
        NSUInteger s =spos.location +spos.length;
        NSUInteger e =epos.location;
        NSRange rang = NSMakeRange(s, e-s);
        key =[key substringWithRange:rang];
    }
    key =[key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key =[key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key =[key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key =[key stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *data = base64_decode(key);
    data =[JDRSAUtil stripPublicKeyHeader:data];
    if (!data) {
        return nil;
    }
    NSString *tag = identifier;
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    //组装一个字典类型的公钥 key
    NSMutableDictionary *publickey =[[NSMutableDictionary alloc]init];
    [publickey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publickey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];
    [publickey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    
    // 向系统的 keychain 中 添加一个私有的 key
    [publickey setObject:data forKey:(__bridge id)kSecValueData];
    [publickey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [publickey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecReturnRef];
    
    CFTypeRef persistkey =nil;
    
    OSStatus status =SecItemAdd((__bridge CFDictionaryRef)publickey, &persistkey);
    if (persistkey != nil) {
        CFRelease(persistkey);
    }
    if ((status != noErr)&&(status != errSecDuplicateItem)) {
        
    }
    if (status == errSecDuplicateItem) {        //如果已经存在则先删除或者直接取到或者更新
        
        //取到原来的
        SecKeyRef seckey = [self geSeckeyRefWithIdentifier:tag];
        if (seckey) {
            return seckey;
        }        //删除
        [self deleSeckeyRefWithIdentifier:tag];
        //update
        
    }
    
    return [self geSeckeyRefWithIdentifier:tag];
    
    
}

+ (void)deleSeckeyRefWithIdentifier:(NSString *)tag
{
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    NSMutableDictionary *publickey =[[NSMutableDictionary alloc]init];
    [publickey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publickey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];
    [publickey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    OSStatus status =  SecItemDelete((__bridge CFDictionaryRef)publickey);
    if (status ==noErr) {
        DLog(@"删除成功!");
    }
}

+ (SecKeyRef)geSeckeyRefWithIdentifier:(NSString *)tag
{
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    //组装一个字典类型的公钥 key
    NSMutableDictionary *publickey =[[NSMutableDictionary alloc]init];
    [publickey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publickey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];
    [publickey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    [publickey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [publickey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id) kSecReturnRef];
    
    //    [publickey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    
    [publickey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publickey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    SecKeyRef keyRef = nil;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)publickey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}


#pragma mark -  密钥对 Data 加密
+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef isSign:(BOOL)isSign{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (isSign) {
            status =SecKeyRawSign(keyRef,
                                  kSecPaddingPKCS1,
                                  srcbuf + idx,
                                  data_len,
                                  outbuf,
                                  &outlen
                                  );
        }
        if (status != 0) {
            DLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}
#pragma mark - 证书对 Data 解密
+ (NSData *)decryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            DLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        }else{
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

#pragma mark - ==============OpenSSL 方式=================


@end
