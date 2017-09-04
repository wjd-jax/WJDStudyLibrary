//
//  AppDelegate+JDPush.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "AppDelegate+JDPush.h"

@implementation AppDelegate (JDPush)

- (void)regisNotification
{
    
    /***策略1****/
    //按钮1
    UIMutableUserNotificationAction * action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1"; //事件ID
    action1.title=@"推迟";
    
    //前台执行还是后台执行
    //UIUserNotificationActivationModeForeground-->前台,
    //UIUserNotificationActivationModeBackground-->后台
    action1.activationMode = UIUserNotificationActivationModeBackground;
    //是否应在执行前需要解锁。如果UIUserNotificationActivationModeForeground激活模式,该属性将被忽略,需要解锁才能使用。
    action1.authenticationRequired = NO;
    //展示这个动作是否是破坏性的(标红)
    action1.destructive = NO;
    //按钮2
    UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = @"action2";
    action2.title=@"关闭";
    action2.activationMode = UIUserNotificationActivationModeBackground;
    action2.authenticationRequired = NO;
    action2.destructive = NO;
    
    UIMutableUserNotificationCategory * categoryOne = [[UIMutableUserNotificationCategory alloc] init];
    categoryOne.identifier = @"categoryOne";
    [categoryOne setActions:@[action2,action1] forContext:(UIUserNotificationActionContextDefault)];
    
    
    //策略2
    UIMutableUserNotificationAction * action3 = [[UIMutableUserNotificationAction alloc] init];
    action3.identifier = @"action3";
    action3.title=@"推迟10分钟";
    action3.activationMode = UIUserNotificationActivationModeForeground;
    action3.destructive = YES;
    
    UIMutableUserNotificationAction * action4 = [[UIMutableUserNotificationAction alloc] init];
    action4.identifier = @"action4";
    action4.title=@"推迟5分钟";
    action4.activationMode = UIUserNotificationActivationModeBackground;
    action4.authenticationRequired = NO;
    action4.destructive = NO;
    
    UIMutableUserNotificationCategory * categoryTwo = [[UIMutableUserNotificationCategory alloc] init];
    categoryTwo.identifier = @"categoryTwo";
    [categoryTwo setActions:@[action4,action3] forContext:(UIUserNotificationActionContextDefault)];
    
    
    //注册所以策略
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects: categoryOne,categoryTwo, nil]];
    [[UIApplication sharedApplication] registerUserNotificationSettings: uns];
    
    //该函数的作用是向苹果服务器注册该设备，注册成功过后会回调(需要有推送证书)--(需要IOS8以上)
    //[[UIApplication sharedApplication] registerForRemoteNotifications];
    
}
//本地推送通知
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //成功注册registerUserNotificationSettings:后，回调的方法
    DLog(@"成功注册registerUserNotificationSetting");
}

//前台收到本地推送调用的方法
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //收到本地推送消息后调用的方法
    DLog(@"收到本地推送消息后调用的方法");
    [JDMessageView showMessage:@"收到本地推送"];
}
//后台收到本地推送调用的方法
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler
{
    //在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
    DLog(@"%@----%@",identifier,notification);
    //创建一个2秒后的本地推送
    if ([identifier isEqualToString:@"action1"]) {

        UILocalNotification *noti = [[UILocalNotification alloc] init];
        noti.alertBody = @"选择推迟的时间";
        noti.category = @"categoryTwo";
        [[UIApplication sharedApplication]  scheduleLocalNotification:noti];

    }
    else
    {
        //取消本地推送
        NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
        DLog(@"%@",array);
        //便利这个数组 根据 key 拿到我们想要的 UILocalNotification
        for (UILocalNotification * loc in array) {
            if ([[loc.userInfo objectForKey:@"key"] isEqualToString:[notification.userInfo objectForKey:@"key"]]) {
                //取消 本地推送
                DLog(@"取消本地推送");
                [[UIApplication sharedApplication] cancelLocalNotification:loc];
            }
        }
        
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    completionHandler();//处理完消息，最后一定要调用这个代码块
}

//远程推送通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //向APNS注册成功，收到返回的deviceToken
    DLog(@"%@",deviceToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //向APNS注册失败，返回错误信息error
    DLog(@"%@",error);

}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到远程推送通知消息
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler
{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
}
@end
