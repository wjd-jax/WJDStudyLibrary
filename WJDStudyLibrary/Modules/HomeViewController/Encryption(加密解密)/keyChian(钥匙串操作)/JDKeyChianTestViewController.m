//
//  JDKeyChianTestViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDKeyChianTestViewController.h"
#import "JDKeyChainWapper.h"
static NSString *const passWord =@"com.pass.text";
@interface JDKeyChianTestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@end

@implementation JDKeyChianTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)savePassClick:(id)sender {
    
    NSDictionary *dic =@{@"userName":_userTextField.text,@"pass":_passwordTextField.text};
    BOOL yes = [JDKeyChainWapper savePassWordDataWithdIdentifier:passWord data:dic accessGroup:nil];
    [JDMessageView showMessage:yes?@"保存成功":@"保存失败"];
    
}
- (IBAction)readPassWordClick:(id)sender {
    
    NSDictionary *dic =[JDKeyChainWapper loadPassWordDataWithIdentifier:passWord accessGroup:nil];
    _passwordLabel.text =[NSString stringWithFormat:@"读取的密码结果是:%@",dic[@"pass"]];
    _userLabel.text =[NSString stringWithFormat:@"读取的用户名结果是:%@",dic[@"userName"]];
    
}

- (IBAction)delete:(id)sender {
    [JDKeyChainWapper deletePassWordClassDataWithIdentifier:passWord accessGroup:nil];
    [self readPassWordClick:nil];
}
@end
