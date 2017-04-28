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
        _publicKeyBase64 =[self base64EncodedFromPEMFormat:pemPublickey];
        _privateKeyBase64 =[self base64EncodedFromPEMFormat:pemPrivatekey];
        [self showTextView:pemPublickey];
        [self showTextView:pemPrivatekey];
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
    
}
- (IBAction)readPrivateSeckey:(id)sender {
    SecKeyRef sec =  [JDKeyChainWapper loadSecKeyRefWithIdentifier:privateKeyChainTag isPublicKey:NO];
    if (sec) {
        [self showTextView:@"从 keyChain中私钥公钥成功"];
        [self showTextView:CFBridgingRelease(sec)];
    }
    
    
}
- (IBAction)saveRASKeyToKeyChain:(id)sender {
    if (!_publicKeyBase64||!_privateKeyBase64) {
        [JDMessageView showMessage:@"密钥对还没有生成!"];
        return;
    }
    
    SecKeyRef pub =  [JDRSAUtil addKeyChainWithRSAkey:_publicKeyBase64 identifier:publicKeyChainTag isPublicKey:YES];
    SecKeyRef pri = [JDRSAUtil addKeyChainWithRSAkey:_privateKeyBase64 identifier:privateKeyChainTag isPublicKey:NO];
    [self showTextView:pub?@"RAS公钥保存成功":@"RSA公钥保存失败"];
    [self showTextView:pri?@"RSA私钥保存成功":@"RSA私钥保存失败"];
    
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
@end
