//
//  JDTouchIDViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/18.
//  Copyright © 2017年 wangjundong. All rights reserved.
//  需要导入LocalAuthentication这个 framework

#import "JDTouchIDViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <Availability.h>
@interface JDTouchIDViewController ()

@end

@implementation JDTouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"touchID";
    UIButton *button =[JDUtils createSystemButtonWithFrame:CGRectMake(0, 0, 150, 30) Target:self Action:@selector(buttonClick) Title:@"验证 TouchID"];
    button.center =self.view.center;
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
}
- (void)buttonClick {
    
    LAContext *context =[[LAContext alloc]init];
    
    // 当指纹识别失败一次后，弹框会多出一个选项，而这个属性就是用来设置那个选项的内容
    context.localizedFallbackTitle = @"使用密码登录"; //设置为@""则不显示
    
    __block  NSString *message;
    
    NSError *error = nil;
    
    //第一个枚举LAPolicyDeviceOwnerAuthenticationWithBiometrics就是说，用的是手指指纹去验证的；iOS8 可用
    //第二个枚举LAPolicyDeviceOwnerAuthentication少了WithBiometrics则是使用TouchID或者密码验证,默认是错误两次指纹或者锁定后,弹出输入密码界面;iOS 9可用
    //注意如果采用第二种,    context.localizedFallbackTitle = @"使用密码登录";这个设置无效因为会直接跳转到输入密码界面
    
    
    LAPolicy lapolicy = iOS9?LAPolicyDeviceOwnerAuthentication:LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    
    /*
     localizedFallbackTitle可以设置验证TouchID时弹出Alert的输入密码按钮的标题
     localizedCancelTitle可以设置验证TouchID时弹出Alert的取消按钮的标题(iOS10才有)
     maxBiometryFailures 最大指纹尝试错误次数。 这个属性我们可以看到他后面写了NS_DEPRECATED_IOS(8_3, 9_0)，说明这个属性在iOS 8.3被引入，在iOS 9.0被废弃，所以如果系统版本高于9.0是无法使用的。
     evalueatedPolicyDomainState这个跟可以检测你的指纹数据库的变化,增加或者删除指纹这个属性会做出相应的反应
     touchIDAuthenticationAllowableReuseDuration这个属性应该是类似于支付宝的指纹开启应用，如果你打开他解锁之后，按Home键返回桌面，再次进入支付宝是不需要录入指纹的。因为这个属性可以设置一个时间间隔，在时间间隔内是不需要再次录入。默认是0秒，最长可以设置5分钟。
     */
    BOOL touchAvailable =[context canEvaluatePolicy:lapolicy error:&error];
    NSData *data =[[NSUserDefaults standardUserDefaults] objectForKey:@"LAContent"];
    /*
     当你增加或者删除指纹时候,你在使用使用canEvaluatePolicy(_:error:)或者evaluatePolicy(_:localizedReason:reply:)方法验证;成功后evaluatedPolicyDomainState属性会返回一个 NSData 对象;否则返回 nil;
     但是返回的evaluatedPolicyDomainState属性并不能说明发生了什么样子的改变;只是告诉你发生了改变
     */
    if (!data) {
        DLog(@"设置evaluatedPolicyDomainState%@--",context.evaluatedPolicyDomainState);
        [[NSUserDefaults standardUserDefaults] setObject:context.evaluatedPolicyDomainState forKey:@"LAContent"];
    }
    else
    {
        if (![data isEqual:context.evaluatedPolicyDomainState]) {
            [JDMessageView showMessage:@"近期修改过 TouchID,需要重新激活"];
            DLog(@"重新设置 保存的ID数据");
            [[NSUserDefaults standardUserDefaults] setObject:context.evaluatedPolicyDomainState forKey:@"LAContent"];
            return;
        }
        else
        {
            DLog(@"上次到现在没有修改过 ID");
        }
    }
    
    
    if (touchAvailable) {
        //该设备支持指纹识别
        [context evaluatePolicy:lapolicy localizedReason:@"身份验证需要验证是否本人" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                JDDISPATCH_MAIN_THREAD(^{
                    [JDMessageView showMessage:@"验证成功"];
                });
            }
            else
            {
                switch (error.code) {
                    case LAErrorSystemCancel:
                        message =@"系统取消了验证（验证时当前APP被移至后台或者点击了home键导致验证退出时提示）";
                        break;
                    case LAErrorUserCancel:
                        message =@"身份验证被用户取消（当用户点击取消按钮时提示）";
                        break;
                    case LAErrorAuthenticationFailed:
                        // 此处会自动消失，然后下一次弹出的时候，又需要验证数字
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
                        //只有在 LAPolicyDeviceOwnerAuthenticationWithBiometrics时候才会执行
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            message =@"用户选择输入密码，切换主线程处理";
                        }];
                        break;
                    }
                    default:
                    {
                        //touchID被锁定
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            message =@"touchID被锁定";   // 5次失败进入,如果继续验证，则需要输入密码解锁
                            
                        }];
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
        JDDISPATCH_MAIN_THREAD(^{
            [JDMessageView showMessage:message];
        });
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 指纹识别慢的问题
 
 指纹识别启动过程需要2s 左右的时间;如果发现启动比较慢,这个是正常现象
 支付宝和微信为了消除用户的紧张情绪,在开启指纹识别的时候都有放 HUD
 指纹识别完成后,需要返回主线程进行相应的 操作;否者你会发现有时候识别完4-5秒才有反应
 */

@end
