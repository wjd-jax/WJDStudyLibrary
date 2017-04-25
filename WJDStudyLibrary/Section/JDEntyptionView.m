//
//  JDEntyptionView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDEntyptionView.h"

@implementation JDEntyptionView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(void)setType:(EncryptionType)type
{

    _decryptTextView.text =Encryption_MD5 ==type?@"MD5无法解密":@"解密后的结果";
    _encryptionTextView.text =Encryption_RSA ==type?@"公钥加密后的结果每次都不一样,属于正常现象":@"加密的结果";

    [_encryptButton setTitle:type ==Encryption_SIGN?@"签名":@"加密" forState:UIControlStateNormal];
    [_decryptButton setTitle:type ==Encryption_SIGN?@"验证":@"解密" forState:UIControlStateNormal];
}
- (IBAction)encryptClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(encryption)]) {
        [self.delegate encryption];
    }
}
- (IBAction)decryptClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dectyption)]) {
        [self.delegate dectyption];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_inputTextField resignFirstResponder];
    
    return YES;
    
}
@end
