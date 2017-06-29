//
//  JDKeyChainWapper.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//
#pragma mark- 说明
/*
 Keychain是一个用于存储敏感信息的保险箱，IOS中仅存在一个全局性的Keychain，对于有加密必要的数据，IOS会进行加密，每个IOS程序只能够访问属于他自己的Keychain item。
 Keychain item的数据结构
 Keychain中所存储的条目，被称之为Keychain item，其实是一个字典似得数据结构，即一个key对应一个value，我们操作Keychain中的数据的时候，也是以字典的结构来进行操作的。
 Keychain item中存储的数据可以划分为三个区域：
 >  一个表明存储的数据类型，其key前缀为 kSecClass*
 >  一组描述数据信息的属性，其key前缀为 kSecAttr*
 >  存储敏感数据的内容，其key前缀为 kSecValue*
 API
 
 SecItemCopyMatching  // 查询
 SecItemAdd           // 添加
 SecItemUpdate        // 更新
 SecItemDelete        // 删除
 
 操作步骤:
 1、创建一个NSMutableDictionary对象，用于存储或用来设置query条件
 2、设置kSecClass，指明我需要获取什么类型数据
 3、设置对应的kSecAttr属性，用来指明我需要对哪个Keychain item进行操作。
 4、调用IOS中的增删改查函数，传入字典查询条件，并获得对应的结果。（我们当然可以指定我们需要什么返回结果，是BOOL值，还是一组属性或data值）
 
 kSecAttr——唯一标识Keychain item的关键 每个Keychain item都是用了一组属性来唯一的描述，当我们需要对Keychian item进行操作时，也是通过这组属性来定位的。同时，对于重要的要加密的信息，IOS也是通过几个关键属性来对应生成私钥进行加解密的。对于每个class的关键属性，国外的牛人有如下记录：
 
 类kSecClassGenericPassword的钥匙串,主键是kSecAttrAccount和kSecAttridentifier的结合。
 
 类kSecClassInternetPassword的钥匙串,主键是kSecAttrAccount的结合,kSecAttrSecurityDomain,kSecAttrServer,kSecAttrProtocol,kSecAttrAuthenticationType,kSecAttrPort kSecAttrPath。
 
 类kSecClassCertificate的钥匙串,主键是kSecAttrCertificateType的结合,kSecAttrIssuer kSecAttrSerialNumber。
 
 类kSecClassKey的钥匙串,主键是kSecAttrApplicationLabel的结合,kSecAttrApplicationTag,kSecAttrKeyType,kSecAttrKeySizeInBits,kSecAttrEffectiveKeySize,和创造者,开始日期和结束日期还没有暴露于SecItem。
 类的钥匙串kSecClassIdentity我还没找到信息打开源文件中的主键字段,但作为一个身份是一个私钥和一个证书,我认为主键的组合主键字段kSecClassKey kSecClassCertificate。
 
 上述钥匙串属于一个钥匙链访问组,感觉就像钥匙链访问集团(字段kSecAttrAccessGroup)是一个额外的字段主键。
 */
#import "JDKeyChainWapper.h"
#import "JDRSAUtil.h"

@implementation JDKeyChainWapper

#pragma mark - Base64编码

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}
#pragma mark - 保存在Keychian中的IDFV
+(NSString *)getIDFV
{
    NSString *uuid =[self loadStringDataWithIdentifier:@"JD_UUID"];
    if (!uuid) {
        NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [self saveStringWithdIdentifier:@"JD_UUID" data:idfv];
        uuid =idfv;
    }
    return uuid;
}

+ (BOOL)resetUUID
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:@"JD_UUID" accessGroup:nil];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    return YES;
}


#pragma mark 写入

+ (BOOL)addKeyChainWithRSASecKey:(SecKeyRef)SecKey identifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey{
    
    NSMutableDictionary * queryKey = [self getSecKeyRefKeychainQuery:identifier isPublicKey:isPublickey];
    
    [queryKey setObject:(__bridge id)SecKey forKey:(__bridge id)kSecValueRef];
    
    return [self saveQueryKey:queryKey identfier:identifier isPublicKey:isPublickey]?YES:NO;
    
}

+ (SecKeyRef)addKeyChainWithRSAkey:(NSString *)key identifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey
{
    key = [self base64EncodedFromPEMFormat:key];
    
    NSData *data = base64_decode(key);
    data = isPublickey?[JDRSAUtil stripPublicKeyHeader:data]:[JDRSAUtil stripPrivateKeyHeader:data];
    if (!data) {
        return nil;
    }
    
    NSMutableDictionary *queryKey =[self getSecKeyRefKeychainQuery:identifier isPublicKey:isPublickey];
    [queryKey setObject:data forKey:(__bridge id)kSecValueData];
    
    return [self saveQueryKey:queryKey identfier:identifier isPublicKey:isPublickey];
}

+ (SecKeyRef)saveQueryKey:(NSDictionary *)dict identfier:(NSString *)identifier isPublicKey:(BOOL)isPublickey
{
    
    OSStatus status = noErr;
    CFTypeRef result;
    CFDataRef keyData = NULL;
    //如果已经存在,先删除原来的在重新写入
    if (SecItemCopyMatching((__bridge CFDictionaryRef) dict, (CFTypeRef *)&keyData) == noErr) {
        
        [self deleteRASKeyWithIdentifier:identifier isPublicKey:isPublickey];
        status = SecItemAdd((__bridge CFDictionaryRef) dict, &result);
        
        if (status == errSecSuccess) {
            return [self loadSecKeyRefWithIdentifier:identifier isPublicKey:isPublickey];
        }
    }
    
    status = SecItemAdd((__bridge CFDictionaryRef) dict, &result);
    if (status == errSecSuccess) {
        return [self loadSecKeyRefWithIdentifier:identifier isPublicKey:isPublickey];
    }
    
    return nil;
}


+ (BOOL)savePassWordDataWithdIdentifier:(NSString *)identifier data:(id)data accessGroup:(NSString *) accessGroup{
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:identifier accessGroup:accessGroup];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    OSStatus status =  SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status != noErr) {
        return NO;
    }
    return YES;
}

+ (BOOL)saveStringWithdIdentifier:(NSString *)identifier data:(NSString *)str;
{
    
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:identifier accessGroup:nil];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:str] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    OSStatus status =  SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status != noErr) {
        return NO;
    }
    return YES;

}
#pragma mark 读取
+ (id)loadPassWordDataWithIdentifier:(NSString *)identifier accessGroup:(NSString *) accessGroup
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:identifier accessGroup:accessGroup];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            DLog(@"Unarchive of %@ failed: %@", identifier, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
+ (SecKeyRef)loadSecKeyRefWithIdentifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey;
{
    
    NSMutableDictionary *keychainQuery =[self getSecKeyRefKeychainQuery:identifier isPublicKey:isPublickey];
    CFDataRef keyData = NULL;
    //如果已经存在,先删除原来的在重新写入
    if (SecItemCopyMatching((__bridge CFDictionaryRef) keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        return (SecKeyRef)keyData;
    }
    DLog(@"读取失败");
    return nil;
}

+ (NSString *)loadStringDataWithIdentifier:(NSString *)identifier
{
    NSString *ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:identifier accessGroup:nil];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            DLog(@"Unarchive of %@ failed: %@", identifier, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

#pragma mark 删除
+ (void)deletePassWordClassDataWithIdentifier:(NSString *)identifier accessGroup:(NSString *) accessGroup
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:identifier accessGroup:accessGroup];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
+ (BOOL)deleteRASKeyWithIdentifier:(NSString *)identifier isPublicKey:(BOOL)isPublickey;
{
    OSStatus status = noErr;
    NSMutableDictionary * queryKey = [self getSecKeyRefKeychainQuery:identifier isPublicKey:isPublickey];
    status = SecItemDelete((__bridge CFDictionaryRef) queryKey);
    
    DLog(@"删除%@",(int)status ==0?@"成功":@"失败");
    return status ==noErr;
    
}

#pragma mark - 通用方法

+ (NSMutableDictionary *)getSecKeyRefKeychainQuery:(NSString *)identifier isPublicKey:(BOOL)isPublickey{
    
    NSData *d_tag = [NSData dataWithBytes:[identifier UTF8String] length:[identifier length]];
    NSMutableDictionary *publickey =[[NSMutableDictionary alloc]init];
    [publickey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publickey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id) kSecAttrKeyType];
    [publickey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    [publickey setObject:(id)(isPublickey?kSecAttrKeyClassPublic:kSecAttrKeyClassPrivate) forKey:(id)kSecAttrKeyClass];
    [publickey setObject:@YES forKey:(__bridge id) kSecReturnRef];
    
    return publickey;
}


//获取通用密码类型的一个查询体
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)identifier accessGroup:(NSString *)accessGroup
{
    
    
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               (id)kSecClassGenericPassword,(id)kSecClass,
                               identifier, (id)kSecAttrAccount,//一般密码
                               (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
                               nil];
    if (accessGroup) {
        [dic setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
        [dic setObject:identifier forKey:(id)kSecAttrGeneric];
        
        /*
         kSecAttrAccessGroup
         
         如果希望这个keychain的item可以被多个应用share，可以给这个item设置这个属性，类型是CFStringRef。应用程序在被编译时，可以在entitlement中指定自己的accessgroup，如果应用的accessgroup名字和keychain item的accessgroup名字一致，那这个应用就可以访问这个item，不过这个设计并不是很好，因为应用的accessgroup是由应用开发者指定的，它可以故意跟其他应用的accessgroup一样，从而访问其他应用的item，更可怕的是还支持wildcard，比如keychain-dumper将自己的accessgroup指定为*，从而可以把keychain中的所有item都dump出来。
         实测,如果设置了这个属性,读取写入的时候会出现-34018错误,应该是这个属性会迫使 app 检测是否开启了 group id 证书.
         如果想要实现分享 keychain 给别的 App 共享,这个基本的功能,可以这样做
         
         需要开启 Tag-Capabilities-Share KeyChian 选项
         在keychain sharing 里添加你要分享的另一个APP的bundle ID
         但是这样也会出现,如果知道你的谋和 app 的 bundleID 就能读取你的 item的情况出现.
         所以如果想要实现安全的 kechain 公钥,需要配合 groupid实现比较好.但是需要证书支持才可以.
         */
        
    }
    return dic;
}

//返回需要的 key 字符串
+ (NSString *)base64EncodedFromPEMFormat:(NSString *)PEMFormat
{
    /*
     -----BEGIN RSA PRIVATE KEY-----
     中间是需要的 key 的字符串
     -----END RSA PRIVATE KEY----
     */
    
    PEMFormat = [PEMFormat stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    PEMFormat = [PEMFormat stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    PEMFormat = [PEMFormat stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    PEMFormat = [PEMFormat stringByReplacingOccurrencesOfString:@" "  withString:@""];
    if (![PEMFormat containsString:@"-----"]) {
        return PEMFormat;
    }
    NSString *key = [[PEMFormat componentsSeparatedByString:@"-----"] objectAtIndex:2];
    
    
    
    return key?key:PEMFormat;
}

@end

#pragma mark- 密钥类型
//密钥类型键
//CFTypeRef kSecClass
//
//值
//CFTypeRef kSecClassGenericPassword            //一般密码
//CFTypeRef kSecClassInternetPassword           //网络密码
//CFTypeRef kSecClassCertificate                //证书
//CFTypeRef kSecClassKey                        //密钥
//CFTypeRef kSecClassIdentity                   //身份证书(带私钥的证书)

//
//不同类型的钥匙串项对应的属性不同
//
//一般密码
//kSecClassGenericPassword
//
//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCreationDate
//kSecAttrModificationDate
//kSecAttrDescription
//kSecAttrComment
//kSecAttrCreator
//kSecAttrType
//kSecAttrLabel
//kSecAttrIsInvisible
//kSecAttrIsNegative
//kSecAttrAccount
//kSecAttridentifier
//kSecAttrGeneric

//网络密码
//kSecClassInternetPassword
//
//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCreationDate
//kSecAttrModificationDate
//kSecAttrDescription
//kSecAttrComment
//kSecAttrCreator
//kSecAttrType
//kSecAttrLabel
//kSecAttrIsInvisible
//kSecAttrIsNegative
//kSecAttrAccount
//kSecAttrSecurityDomain
//kSecAttrServer
//kSecAttrProtocol
//kSecAttrAuthenticationType
//kSecAttrPort
//kSecAttrPath

//证书
//kSecClassCertificate
//
//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrCertificateType
//kSecAttrCertificateEncoding
//kSecAttrLabel
//kSecAttrSubject
//kSecAttrIssuer
//kSecAttrSerialNumber
//kSecAttrSubjectKeyID
//kSecAttrPublicKeyHash

//密钥
//kSecClassKey
//
//对应属性
//kSecAttrAccessible
//kSecAttrAccessGroup
//kSecAttrKeyClass
//kSecAttrLabel
//kSecAttrApplicationLabel
//kSecAttrIsPermanent
//kSecAttrApplicationTag
//kSecAttrKeyType
//kSecAttrKeySizeInBits
//kSecAttrEffectiveKeySize
//kSecAttrCanEncrypt
//kSecAttrCanDecrypt
//kSecAttrCanDerive
//kSecAttrCanSign
//kSecAttrCanVerify
//kSecAttrCanWrap
//kSecAttrCanUnwrap

//身份证书(带私钥的证书)
//kSecClassIdentity
//
//对应属性
//   证书属性
//   私钥属性



#pragma mark- 属性
//键
//CFTypeRef kSecAttrAccessible;                                        //可访问性 类型透明
//值
//          CFTypeRef kSecAttrAccessibleWhenUnlocked;                  //解锁可访问，备份
//          CFTypeRef kSecAttrAccessibleAfterFirstUnlock;              //第一次解锁后可访问，备份
//          CFTypeRef kSecAttrAccessibleAlways;                        //一直可访问，备份
//          CFTypeRef kSecAttrAccessibleWhenUnlockedThisDeviceOnly;    //解锁可访问，不备份
//          CFTypeRef kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;//第一次解锁后可访问，不备份
//          CFTypeRef kSecAttrAccessibleAlwaysThisDeviceOnly;          //一直可访问，不备份

//CFTypeRef kSecAttrCreationDate;      //创建日期          CFDateRef
//CFTypeRef kSecAttrModificationDate;  //最后一次修改日期   CFDateRef
//CFTypeRef kSecAttrDescription;       //描述             CFStringRef
//CFTypeRef kSecAttrComment;           //注释             CFStringRef
//CFTypeRef kSecAttrCreator;           //创建者            CFNumberRef(4字符，如'aLXY')
//CFTypeRef kSecAttrType;              //类型             CFNumberRef(4字符，如'aTyp')
//CFTypeRef kSecAttrLabel;             //标签(给用户看)     CFStringRef
//CFTypeRef kSecAttrIsInvisible;       //是否隐藏          CFBooleanRef(kCFBooleanTrue,kCFBooleanFalse)
//CFTypeRef kSecAttrIsNegative;        //是否具有密码       CFBooleanRef(kCFBooleanTrue,kCFBooleanFalse)此项表示当前的item是否只是一个占位项，或者说是只有key没有value。
//CFTypeRef kSecAttrAccount;           //账户名            CFStringRef
//CFTypeRef kSecAttridentifier;           //所具有服务         CFStringRef
//CFTypeRef kSecAttrGeneric;           //用户自定义内容      CFDataRef
//CFTypeRef kSecAttrSecurityDomain;    //网络安全域         CFStringRef
//CFTypeRef kSecAttrServer;            //服务器域名或IP地址  CFStringRef

//键
//CFTypeRef kSecAttrProtocol;                      //协议类型 CFNumberRef
//          值
//          CFTypeRef kSecAttrProtocolFTP;         //
//          CFTypeRef kSecAttrProtocolFTPAccount;  //
//          CFTypeRef kSecAttrProtocolHTTP;        //
//          CFTypeRef kSecAttrProtocolIRC;         //
//          CFTypeRef kSecAttrProtocolNNTP;        //
//          CFTypeRef kSecAttrProtocolPOP3;        //
//          CFTypeRef kSecAttrProtocolSMTP;        //
//          CFTypeRef kSecAttrProtocolSOCKS;       //
//          CFTypeRef kSecAttrProtocolIMAP;        //
//          CFTypeRef kSecAttrProtocolLDAP;        //
//          CFTypeRef kSecAttrProtocolAppleTalk;   //
//          CFTypeRef kSecAttrProtocolAFP;         //
//          CFTypeRef kSecAttrProtocolTelnet;      //
//          CFTypeRef kSecAttrProtocolSSH;         //
//          CFTypeRef kSecAttrProtocolFTPS;        //
//          CFTypeRef kSecAttrProtocolHTTPS;       //
//          CFTypeRef kSecAttrProtocolHTTPProxy;   //
//          CFTypeRef kSecAttrProtocolHTTPSProxy;  //
//          CFTypeRef kSecAttrProtocolFTPProxy;    //
//          CFTypeRef kSecAttrProtocolSMB;         //
//          CFTypeRef kSecAttrProtocolRTSP;        //
//          CFTypeRef kSecAttrProtocolRTSPProxy;   //
//          CFTypeRef kSecAttrProtocolDAAP;        //
//          CFTypeRef kSecAttrProtocolEPPC;        //
//          CFTypeRef kSecAttrProtocolIPP;         //
//          CFTypeRef kSecAttrProtocolNNTPS;       //
//          CFTypeRef kSecAttrProtocolLDAPS;       //
//          CFTypeRef kSecAttrProtocolTelnetS;     //
//          CFTypeRef kSecAttrProtocolIMAPS;       //
//          CFTypeRef kSecAttrProtocolIRCS;        //
//          CFTypeRef kSecAttrProtocolPOP3S;       //

//键
//CFTypeRef kSecAttrAuthenticationType;                      //认证类型 CFNumberRef
//          值
//          CFTypeRef kSecAttrAuthenticationTypeNTLM;        //
//          CFTypeRef kSecAttrAuthenticationTypeMSN;         //
//          CFTypeRef kSecAttrAuthenticationTypeDPA;         //
//          CFTypeRef kSecAttrAuthenticationTypeRPA;         //
//          CFTypeRef kSecAttrAuthenticationTypeHTTPBasic;   //
//          CFTypeRef kSecAttrAuthenticationTypeHTTPDigest;  //
//          CFTypeRef kSecAttrAuthenticationTypeHTMLForm;    //
//          CFTypeRef kSecAttrAuthenticationTypeDefault;     //

//CFTypeRef kSecAttrPort;                 //网络端口           CFNumberRef
//CFTypeRef kSecAttrPath;                 //访问路径           CFStringRef
//CFTypeRef kSecAttrSubject;              //X.500主题名称      CFDataRef
//CFTypeRef kSecAttrIssuer;               //X.500发行者名称     CFDataRef
//CFTypeRef kSecAttrSerialNumber;         //序列号             CFDataRef
//CFTypeRef kSecAttrSubjectKeyID;         //主题ID             CFDataRef
//CFTypeRef kSecAttrPublicKeyHash;        //公钥Hash值         CFDataRef
//CFTypeRef kSecAttrCertificateType;      //证书类型            CFNumberRef
//CFTypeRef kSecAttrCertificateEncoding;  //证书编码类型        CFNumberRef

//CFTypeRef kSecAttrKeyClass;                     //加密密钥类  CFTypeRef
//          值
//          CFTypeRef kSecAttrKeyClassPublic;     //公钥
//          CFTypeRef kSecAttrKeyClassPrivate;    //私钥
//          CFTypeRef kSecAttrKeyClassSymmetric;  //对称密钥

//CFTypeRef kSecAttrApplicationLabel;  //标签(给程序使用)          CFStringRef(通常是公钥的Hash值)
//CFTypeRef kSecAttrIsPermanent;       //是否永久保存加密密钥       CFBooleanRef
//CFTypeRef kSecAttrApplicationTag;    //标签(私有标签数据)         CFDataRef

//CFTypeRef kSecAttrKeyType;  //加密密钥类型(算法)   CFNumberRef
//          值
//          extern const CFTypeRef kSecAttrKeyTypeRSA;

//CFTypeRef kSecAttrKeySizeInBits;     //密钥总位数               CFNumberRef
//CFTypeRef kSecAttrEffectiveKeySize;  //密钥有效位数              CFNumberRef
//CFTypeRef kSecAttrCanEncrypt;        //密钥是否可用于加密         CFBooleanRef
//CFTypeRef kSecAttrCanDecrypt;        //密钥是否可用于加密         CFBooleanRef
//CFTypeRef kSecAttrCanDerive;         //密钥是否可用于导出其他密钥   CFBooleanRef
//CFTypeRef kSecAttrCanSign;           //密钥是否可用于数字签名      CFBooleanRef
//CFTypeRef kSecAttrCanVerify;         //密钥是否可用于验证数字签名   CFBooleanRef
//CFTypeRef kSecAttrCanWrap;           //密钥是否可用于打包其他密钥   CFBooleanRef
//CFTypeRef kSecAttrCanUnwrap;         //密钥是否可用于解包其他密钥   CFBooleanRef
//CFTypeRef kSecAttrAccessGroup;       //访问组                   CFStringRef


#pragma mark- 搜索
//CFTypeRef kSecMatchPolicy;                 //指定策略            SecPolicyRef
//CFTypeRef kSecMatchItemList;               //指定搜索范围         CFArrayRef(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef,CFDataRef)数组内的类型必须唯一。仍然会搜索钥匙串，但是搜索结果需要与该数组取交集作为最终结果。
//CFTypeRef kSecMatchSearchList;             //
//CFTypeRef kSecMatchIssuers;                //指定发行人数组       CFArrayRef
//CFTypeRef kSecMatchEmailAddressIfPresent;  //指定邮件地址         CFStringRef
//CFTypeRef kSecMatchSubjectContains;        //指定主题            CFStringRef
//CFTypeRef kSecMatchCaseInsensitive;        //指定是否不区分大小写  CFBooleanRef(kCFBooleanFalse或不提供此参数,区分大小写;kCFBooleanTrue,不区分大小写)
//CFTypeRef kSecMatchTrustedOnly;            //指定只搜索可信证书    CFBooleanRef(kCFBooleanFalse或不提供此参数,全部证书;kCFBooleanTrue,只搜索可信证书)
//CFTypeRef kSecMatchValidOnDate;            //指定有效日期         CFDateRef(kCFNull表示今天)
//CFTypeRef kSecMatchLimit;                  //指定结果数量         CFNumberRef(kSecMatchLimitOne;kSecMatchLimitAll)
//CFTypeRef kSecMatchLimitOne;               //首条结果
//CFTypeRef kSecMatchLimitAll;               //全部结果


#pragma mark- 列表
//CFTypeRef kSecUseItemList;   //CFArrayRef(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef,CFDataRef)数组内的类型必须唯一。用户提供用于查询的列表。当这个列表被提供的时候，不会再搜索钥匙串。


#pragma mark- 返回值类型
//可以同时指定多种返回值类型
//CFTypeRef kSecReturnData;           //返回数据(CFDataRef)                  CFBooleanRef
//CFTypeRef kSecReturnAttributes;     //返回属性字典(CFDictionaryRef)         CFBooleanRef
//CFTypeRef kSecReturnRef;            //返回实例(SecKeychainItemRef, SecKeyRef, SecCertificateRef, SecIdentityRef, or CFDataRef)         CFBooleanRef
//CFTypeRef kSecReturnPersistentRef;  //返回持久型实例(CFDataRef)             CFBooleanRef


#pragma mark- 写入值类型
//CFTypeRef kSecValueData;
//CFTypeRef kSecValueRef;
//CFTypeRef kSecValuePersistentRef;
