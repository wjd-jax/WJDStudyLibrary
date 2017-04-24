//
//  JDMD5EvntyptionViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDEvntyptionViewController.h"
#import "JDEntyptionView.h"

@interface JDEvntyptionViewController ()<EntyptDelegate>

@property(nonatomic,retain)__block JDEntyptionView *encryptionView;
@property(nonatomic,assign)__block EncryptionType type;
@end

@implementation JDEvntyptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _type =Encryption_MD5;
    
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
    }];
    
    UIAlertAction *rsaAction = [UIAlertAction actionWithTitle:@"RSA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_MD5;
    }];

    
    UIAlertAction *aesAction = [UIAlertAction actionWithTitle:@"AES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_MD5;
    }];
    
    
    UIAlertAction *desAction = [UIAlertAction actionWithTitle:@"DES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_DES;
    }];
    
    UIAlertAction *javaServerORRSAAction = [UIAlertAction actionWithTitle:@"JavaServerORRSA" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _encryptionView.encryptTypeLabel.text =action.title;
        _type =Encryption_JavaServerORRSA;
    }];

    
    [alertController addAction:md5Action];
    [alertController addAction:rsaAction];
    [alertController addAction:aesAction];
    [alertController addAction:desAction];
    [alertController addAction:javaServerORRSAAction];

    [self presentViewController:alertController animated:YES completion:nil];
}
//
-(void)dectyption
{

}
//
-(void)encryption
{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_encryptionView.inputTextField resignFirstResponder];
    return YES;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
