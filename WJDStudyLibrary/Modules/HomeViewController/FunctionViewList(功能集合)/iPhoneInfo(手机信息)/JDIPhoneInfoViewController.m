//
//  JDIPhoneInfoViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDIPhoneInfoViewController.h"

@interface JDIPhoneInfoViewController ()
//手机序列号
@property (weak, nonatomic) IBOutlet UILabel *identifierNumberLabel;    //
//手机别名： 用户定义的名称
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNamelabel;       //
//手机型号
@property (weak, nonatomic) IBOutlet UILabel *phoneModel;               //
//手机系统版本
@property (weak, nonatomic) IBOutlet UILabel *phoneVersion;             //
//设备名称
@property (weak, nonatomic) IBOutlet UILabel *deviceName;               //
//地方型号 （国际化区域名称）
@property (weak, nonatomic) IBOutlet UILabel *localPhoneModel;          //
// 当前应用名称
@property (weak, nonatomic) IBOutlet UILabel *appCurName;               //
// 当前应用软件版本 比如：1.0.1
@property (weak, nonatomic) IBOutlet UILabel *appCurVersion;            //
// 当前应用版本号码 int类型
@property (weak, nonatomic) IBOutlet UILabel *appCurVersionNum;         //

@end

@implementation JDIPhoneInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //UUID 重装后改变；
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    _identifierNumberLabel.text =identifierNumber;
    
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    _userPhoneNamelabel.text = userPhoneName;
    
    //设备名称 e.g. @"iOS"
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    _deviceName.text =deviceName;
    
    //手机系统版本 e.g. @"10.3.1"
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    _phoneVersion.text =phoneVersion;
    
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    _phoneModel.text =phoneModel;
    
    //地方型号 （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    _localPhoneModel.text =localPhoneModel;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    _appCurName.text =appCurName;
    
    // 当前应用软件版本 比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _appCurVersion.text =appCurVersion;
    
    // 当前应用版本号码 int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    _appCurVersionNum.text =appCurVersionNum;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
