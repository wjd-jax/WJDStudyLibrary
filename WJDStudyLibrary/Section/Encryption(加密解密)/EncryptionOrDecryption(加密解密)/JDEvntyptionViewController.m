//
//  JDMD5EvntyptionViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDEvntyptionViewController.h"
#import "JDEntyptionView.h"
#import "JDMD5Util.h"
#import "JDRSAUtil.h"
#import "JDAESUtil.h"
#import "JDDESUtil.h"

#define ENCRYPT_KEY          @"MfsKyo8IEMb"

#define RSA_Test_secret      @"lXOjdiMhPZjxDGF2eUzv7yD6zEFTLjyclrmPNTdMyEYCQC45d4ruo4QbV9jMN5lKfTxz3dxPIPaT06KxqU5CQVZqkX4Ttrw/anZencm4WnVUs96GIgpI3uY7ohOaG36Ak3cGvkQF6DvCO88MPrdS38DxUa2OSG4G5DVl4c74M4g="
//公钥
#define RSA_Public_key         @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCxuWhp6EgQfrrSBtxlBwbU35lhjC67X0Y1KrhqolIfYo3/yWV1eryYVUhk5xeHsbKg9RHD9TpIZRUWIW5a8MrMBcgr1A/dgIHi2EM28drH4JRTmkTLVHReggFbb046k0ISpLW3XVW0jHB3/z3S1c/NT9V63SQK6WJ65/YP5xISNQIDAQAB"
//私钥
#define RSA_Privite_key      @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALG5aGnoSBB+utIG3GUHBtTfmWGMLrtfRjUquGqiUh9ijf/JZXV6vJhVSGTnF4exsqD1EcP1OkhlFRYhblrwyswFyCvUD92AgeLYQzbx2sfglFOaRMtUdF6CAVtvTjqTQhKktbddVbSMcHf/PdLVz81P1XrdJArpYnrn9g/nEhI1AgMBAAECgYBEbsMAvLs69sFS6+djU1BTGYIC6Kp55ZawFDIMhVIf2aAZ1N+nW8pQ0c3dZIpP6qGAjrz3em6lv55d9iN7Cura/g57Rk4S3SRo5u4hWUd16NeIVP+HfreKIgZ6jwKQTfXt2KzDuIAHudvwT2UJBePgIIDQoKMEq4khtFiRGS1UgQJBAN/KpSOiRiGup8h/Iqespwfxyrqn5/4iyw1tpJCWzHddP7nJGpYmOL+ELWs/pReYclAOqH9ZIzOT2K8ZLt6yBOECQQDLTXZowK8wFgMudAE5TStC/zl3TAKMu/Gu5wlXSMoa+nwSy/FSIQZyypGeHR2X8QhbZ1Qz+uBCJm7gEGOWMWPVAkEAp5ajsFm3V0XqE/VRSGu88fAaN0nCK8h2cunm0Ph8ye6k6EY3iLW6zYD4WlZhFZhuEpHHkQZ5nAhdvlKHjPGXQQJAYOtF1rx9B/SGgb/F0ZZrWF4p/ChdUtBKcHIt7tGBoAjn22IkYl3iIBlYAEOrFwNOU5zX9IvWG1MNKn5Fq5VSHQJBAJG5xSY0IKzXWDsGnPIa9XlSTv1zl7RCGNDo7O1zh+5J/kjDpU9M2fIXEtzvGYHiOffz9FBh5ka69JJNFWoWAiw="




@interface JDEvntyptionViewController ()<EntyptDelegate>

@property(nonatomic,retain)__block JDEntyptionView *encryptionView;
@property(nonatomic,assign)__block EncryptionType type;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *ret;

@end

@implementation JDEvntyptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _type =Encryption_MD5;
    _encryptionView.type =_type;
    _encryptionView = [[[NSBundle mainBundle] loadNibNamed:@"EnvtyptionView" owner:self options:nil] firstObject];
    _encryptionView.delegate =self;
    _encryptionView.frame = CGRectMake(0, 64, SCREEN_WIDHT, SCREEN_HEIGHT-64);
    [self.view addSubview:_encryptionView];
    
    UIBarButtonItem *rightBarItem =[JDUtils createTextBarButtonWithTitle:@"设置加密方式" Target:self Action:@selector(setClick)];
    self.navigationItem.rightBarButtonItem =rightBarItem;
    
    // Do any additional setup after loading the view.
}
//
- (void)setClick {
    
    UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"选择加密方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *md5Action = [UIAlertAction actionWithTitle:@"MD5" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_MD5;
        _encryptionView.type =_type;
        
    }];
    
    UIAlertAction *rsaAction = [UIAlertAction actionWithTitle:@"RSA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_RSA;
        _encryptionView.type =_type;
        
    }];
    
    
    UIAlertAction *aesAction = [UIAlertAction actionWithTitle:@"AES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_AES;
        _encryptionView.type =_type;
        
    }];
    
    
    UIAlertAction *desAction = [UIAlertAction actionWithTitle:@"DES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_DES;
        _encryptionView.type =_type;
        
    }];
    
    /*
     UIAlertAction *javaServerORRSAAction = [UIAlertAction actionWithTitle:@"JavaServerORRSA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     _encryptionView.encryptTypeLabel.text =action.title;
     _type =Encryption_JavaServerORRSA;
     _encryptionView.type =_type;
     
     }];
     
     */
    UIAlertAction *signAction = [UIAlertAction actionWithTitle:@"RSA签名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_SIGN;
        _encryptionView.type =_type;
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil];
    
    [alertController addAction:md5Action];
    [alertController addAction:rsaAction];
    [alertController addAction:aesAction];
    [alertController addAction:desAction];
    [alertController addAction:signAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -  加密
-(void)encryption
{
    _key =[self randomKey];

    switch (_type) {
        case Encryption_MD5:
            _encryptionView.encryptionTextView.text = [JDMD5Util md5:_encryptionView.inputTextField.text];
            break;
        case Encryption_RSA:
            //公钥加密
            _encryptionView.encryptionTextView.text =[JDRSAUtil encryptString:_encryptionView.inputTextField.text publicKey:RSA_Public_key];
            break;
        case Encryption_SIGN:
            //私钥加密
            _encryptionView.encryptionTextView.text =[JDRSAUtil signatureString:_encryptionView.inputTextField.text privateKey:RSA_Privite_key];
            break;
        case Encryption_AES:
            //私钥加密
        {
            _ret  =[JDAESUtil encrypt:_encryptionView.inputTextField.text password:_key];
            _encryptionView.encryptionTextView.text =[NSString stringWithFormat:@"随机密码:%@\n加密结果:%@",_key,_ret];
        }
            break;
        case Encryption_DES:
            //私钥加密
        {
            _key =[self randomKey];
            _ret  =[JDDESUtil encryptUseDES:_encryptionView.inputTextField.text key:_key];
            _encryptionView.encryptionTextView.text =[NSString stringWithFormat:@"随机密码:%@\n加密结果:%@",_key,_ret];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -  解密
-(void)dectyption
{
    switch (_type) {
        case Encryption_MD5:
            [JDMessageView showMessage:@"MD5无法解密"];
            break;
        case Encryption_RSA:
            //私钥解密
            _encryptionView.decryptTextView.text =[JDRSAUtil decryptString:_encryptionView.encryptionTextView.text privateKey:RSA_Privite_key];
            break;
        case Encryption_SIGN:
            //公钥验证
            _encryptionView.decryptTextView.text =[JDRSAUtil decryptString:_encryptionView.encryptionTextView.text publicKey:RSA_Public_key];
            break;
        case Encryption_AES:
            
            _encryptionView.decryptTextView.text =[JDAESUtil decrypt:_ret password:_key];
            break;
        case Encryption_DES:
            
            _encryptionView.decryptTextView.text =[JDDESUtil decryptUseDES:_ret key:_key];
            break;
        default:
            break;
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_encryptionView.inputTextField resignFirstResponder];
    return YES;
    
}
#pragma mark - 随机密码
//生成八位随机字符串
- (NSString *)randomKey {
    
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform((float)numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:8];
    free(characters);
    return result;
}
@end
