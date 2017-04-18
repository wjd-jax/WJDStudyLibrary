//
//  JDTouchIDViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/18.
//  Copyright © 2017年 wangjundong. All rights reserved.
//  需要导入LocalAuthentication这个 framework

#import "JDTouchIDViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface JDTouchIDViewController ()

@end

@implementation JDTouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"touchID";
    UIButton *button =[JDUtils createButtonWithFrame:CGRectMake(0, 0, 150, 30) ImageName:nil Target:self Action:@selector(buttonClick) Title:@"验证 TouchID"];
    button.center =self.view.center;
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}
- (void)buttonClick {
    LAContext *context =[[LAContext alloc]init];
    // 当指纹识别失败一次后，弹框会多出一个选项，而这个属性就是用来设置那个选项的内容
    context.localizedFallbackTitle = @"使用密码登录";
    __block  NSString *message;
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //该设备支持指纹识别
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"身份验证需要验证是否本人" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                JDDISPATCH_MAIN_THREAD(^{
                    [JDMessageView showMessage:@"验证成功"];
                });
            }
            else
            {
                switch (error.code) {
                    case LAErrorSystemCancel:
                        message =@"身份验证被系统取消（验证时当前APP被移至后台或者点击了home键导致验证退出时提示）";
                        break;
                    case LAErrorUserCancel:
                        message =@"身份验证被用户取消（当用户点击取消按钮时提示）";
                        break;
                    case LAErrorAuthenticationFailed:
                        message =@"身份验证没有成功，因为用户未能提供有效的凭据(连续3次验证失败时提示)";
                        break;
                    case LAErrorPasscodeNotSet:
                        message =@"Touch ID无法启动，因为没有设置密码（当系统没有设置密码的时候，Touch ID也将不会开启）";
                        break;
                    case LAErrorTouchIDNotAvailable:
                        message =@"无法启动身份验证";  // 这个没有检测到，应该是出现硬件损坏才会出现
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        message =@"无法启动身份验证，因为触摸标识没有注册的手指";  // 这个暂时没检测到
                        break;
                    case LAErrorUserFallback:
                    {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            message =@"用户选择输入密码，切换主线程处理";
//                        }];
                        break;
                    }
                    default:
                    {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            message =@"其他情况，切换主线程处理";   // 5次失败进入,如果继续验证，则需要输入密码解锁
                            
//                        }];
                        break;
                    }
                }
                JDDISPATCH_MAIN_THREAD(^{
                    [JDMessageView showMessage:message];
                });

                
            }
        }];
    }
    else
    {
        DLog(@"不支持指纹识别");
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                message =@"设备Touch ID不可用";
                break;
            case LAErrorPasscodeNotSet:
                message =@"系统未设置密码";
                break;
            default:
                message =@"TouchID不可用或已损坏";
                break;
        }
     
    }
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
