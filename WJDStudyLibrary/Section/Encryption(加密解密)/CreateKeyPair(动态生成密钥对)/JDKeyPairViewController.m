//
//  JDKeyPairViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDKeyPairViewController.h"
#import "JDRSAUtil.h"
#import <openssl/rsa.h>
#import <openssl/pem.h>
#import <openssl/bio.h>
#import "JDKeyChainWapper.h"


//存储钥匙串的 tag
static NSString * const publicKeyChainTag =@"publickeyTag_Seckey";
static NSString * const privateKeyChainTag =@"privatekeyTag_Seckey";

static NSString * const OpenSSL_publicKeyChainTag =@"OpenSSL_publickeyTag_Seckey";
static NSString * const OpenSSL_privateKeyChainTag =@"OpenSSL_privatekeyTag_Seckey";

@interface JDKeyPairViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation JDKeyPairViewController
{
    SecKeyRef _publicKey;
    SecKeyRef _privateKey;
    //
    RSA *openSSLPublicKey;
    RSA *openSSLPrivateKey;
    
    NSString *_publicKeyBase64;
    NSString *_privateKeyBase64;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)crateKeyPairWithOpenSSl:(id)sender {
    
    BOOL yes = [JDRSAUtil generateRSAKeyPairWithKeySize:1024 publicKey:&openSSLPublicKey privateKey:&openSSLPrivateKey];
    if (yes) {
        
        NSString *pemPublickey =[JDRSAUtil PEMFormatRSAKey:openSSLPublicKey isPublic:YES];
        NSString *pemPrivatekey = [JDRSAUtil PEMFormatRSAKey:openSSLPrivateKey isPublic:NO];
        
        //除去-----PUBLICKEY-----获取的纯key 字符串
        _publicKeyBase64 = [self base64EncodedFromPEMFormat:pemPublickey];
        _privateKeyBase64 = [self base64EncodedFromPEMFormat:pemPrivatekey];
        [self showTextView: @"公钥字符串"];
        [self showTextView: _publicKeyBase64];
        [self showTextView: @"私钥字符串"];
        [self showTextView:_privateKeyBase64];
    }
}

//保存系统生成公钥对到 keychain
- (IBAction)saveSeckeyToKeyChain:(id)sender {
    
    if (!_publicKey||!_privateKey) {
        [JDMessageView showMessage:@"密钥对不存在"];
        return;
    }
    BOOL a = [JDKeyChainWapper addKeyChainWithRSASecKey:_publicKey identifier:publicKeyChainTag isPublicKey:YES];
    BOOL b = [JDKeyChainWapper addKeyChainWithRSASecKey:_privateKey identifier:privateKeyChainTag isPublicKey:NO];
    [self showTextView:[NSString stringWithFormat:@"公钥写入Keychain结果%@",@(a)]];
    [self showTextView:[NSString stringWithFormat:@"私钥写入Keychain结果%@",@(b)]];
    
    
}
- (IBAction)readSeckey:(id)sender {
    SecKeyRef sec =  [JDKeyChainWapper loadSecKeyRefWithIdentifier:publicKeyChainTag isPublicKey:YES];
    if (sec) {
        [self showTextView:@"从 keyChain中读取公钥成功"];
        [self showTextView:CFBridgingRelease(sec)];
    }
    else
        [self showTextView:@"从 keyChain中读取公钥失败"];
    
}
- (IBAction)readPrivateSeckey:(id)sender {
    SecKeyRef sec =  [JDKeyChainWapper loadSecKeyRefWithIdentifier:privateKeyChainTag isPublicKey:NO];
    if (sec) {
        [self showTextView:@"从 keyChain中读取私钥成功"];
        [self showTextView:CFBridgingRelease(sec)];
    }
    else
        [self showTextView:@"从 keyChain中读取私钥失败"];
    
    
    
}
#pragma mark - 保存密钥对字符串到 keychain

- (IBAction)saveRASKeyToKeyChain:(id)sender {
    if (!_publicKeyBase64||!_privateKeyBase64) {
        [JDMessageView showMessage:@"密钥对还没有生成!"];
        return;
    }
    
    SecKeyRef pub = [JDKeyChainWapper addKeyChainWithRSAkey:_publicKeyBase64 identifier:OpenSSL_publicKeyChainTag isPublicKey:YES];
    SecKeyRef pri = [JDKeyChainWapper addKeyChainWithRSAkey:_privateKeyBase64 identifier:OpenSSL_privateKeyChainTag isPublicKey:NO];
    [self showTextView:pub?@"RAS公钥保存成功":@"RSA公钥保存失败"];
    [self showTextView:pri?@"RSA私钥保存成功":@"RSA私钥保存失败"];
    
}
#pragma mark - 读取 openssl 生成的密钥
- (IBAction)readPubulicKey:(id)sender {
    
    
    SecKeyRef sec = [JDKeyChainWapper loadSecKeyRefWithIdentifier:OpenSSL_publicKeyChainTag isPublicKey:YES];
    if (sec) {
        [self showTextView:@"从 keyChain中读取公钥成功"];
        [self showTextView:CFBridgingRelease(sec)];
    }
    else
        [self showTextView:@"从 keyChain中读取公钥失败"];
    
}
- (IBAction)radPrivateKey:(id)sender {
    
    
    SecKeyRef sec = [JDKeyChainWapper loadSecKeyRefWithIdentifier:OpenSSL_privateKeyChainTag isPublicKey:NO];
    if (sec) {
        [self showTextView:@"从 keyChain中读取公钥成功"];
        [self showTextView:CFBridgingRelease(sec)];
    }
    else
        [self showTextView:@"从 keyChain中读取公钥失败"];
    
}



- (NSString *)base64EncodedFromPEMFormat:(NSString *)PEMFormat
{
    NSString *keyStr = [[PEMFormat componentsSeparatedByString:@"-----"] objectAtIndex:2];
    keyStr = [keyStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    keyStr = [keyStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    keyStr = [keyStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    keyStr = [keyStr stringByReplacingOccurrencesOfString:@" "  withString:@""];
    return keyStr;
}



- (IBAction)generateKeyPair:(id)sender {
    
    [JDRSAUtil getRSAKeyPairWithKeySize:1024 keyPair:^(SecKeyRef publicKey, SecKeyRef privateKey) {
        
        _publicKey =publicKey;
        _privateKey =privateKey;
        [self showTextView:(__bridge id)(publicKey)];
        [self showTextView:(__bridge id)(privateKey)];
    }];
    
    
}
- (void)showTextView:(id)message
{
    _textView.text =[NSString stringWithFormat:@"%@\n========================\n%@",_textView.text,message];
    [self scrollsToBottomAnimated:YES];
}

- (void)scrollsToBottomAnimated:(BOOL)animated {
    
    CGFloat offset = self.textView.contentSize.height - self.textView.bounds.size.height;
    if (offset > 0)
    {
        CGPoint offset = CGPointMake(0, self.textView.contentSize.height - self.textView.frame.size.height);
        [self.textView setContentOffset:offset animated:animated];
    }
}
- (IBAction)deleteFromKeyChain:(id)sender {
    
    BOOL a = [JDKeyChainWapper deleteRASKeyWithIdentifier:publicKeyChainTag isPublicKey:YES];
    BOOL b = [JDKeyChainWapper deleteRASKeyWithIdentifier:privateKeyChainTag isPublicKey:NO];
    BOOL c = [JDKeyChainWapper deleteRASKeyWithIdentifier:OpenSSL_publicKeyChainTag isPublicKey:YES];
    BOOL d = [JDKeyChainWapper deleteRASKeyWithIdentifier:OpenSSL_privateKeyChainTag isPublicKey:NO];
    
    [self showTextView:a?@"删除Sec公钥成功":@"删除Sec公钥失败"];
    [self showTextView:b?@"删除Sec公钥成功":@"删除Sec公钥失败"];
    [self showTextView:c?@"删除OpenSSL_key公钥成功":@"删除OpenSSL_key公钥失败"];
    [self showTextView:d?@"删除OpenSSL_key公钥成功":@"删除OpenSSL_key公钥失败"];
    
}
#pragma mark - 重置
- (IBAction)restAll:(id)sender {
    _publicKeyBase64 =@"";
    _privateKeyBase64 =@"";
    _publicKey =nil;
    _privateKey =nil;
    openSSLPublicKey =nil;
    openSSLPrivateKey =nil;
    _showResultTextView.text =@"";
}
@end
