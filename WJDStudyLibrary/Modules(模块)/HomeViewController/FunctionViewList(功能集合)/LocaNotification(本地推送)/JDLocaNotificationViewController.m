//
//  JDLocaNotificationViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDLocaNotificationViewController.h"

@interface JDLocaNotificationViewController ()

@end

@implementation JDLocaNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *sysbuton =[JDUtils createSystemButtonWithFrame:CGRectMake(0, 0, 200, 20) Target:self Action:@selector(starClick) Title:@"点击添加一个推送"];
    sysbuton.center = self.view.center;
    [self.view addSubview:sysbuton];
}

- (void)starClick {
    
    [JDMessageView showMessage:@"推送将在5秒后执行"];
    //创建一个2秒后的本地推送
    
    /*
     
     设置提醒时间，有三种方式可以进行设置
     
     UNTimeIntervalNotificationTrigger多长时间之后发送推送
     UNCalendarNotificationTrigger根据日历推送
     
     UNLocationNotificationTrigger根据位置推送
     
     代码分别如下:
     
     UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];//timeInterval单位为秒
     //每周一下午 6：00 打卡
     NSDateComponents *components = [[NSDateComponents alloc] init];
     components.weekday = 2;
     components.hour = 18;
     UNCalendarNotificationTrigger *trigger2 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
     
     */
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:5];
    notification.timeZone=[NSTimeZone defaultTimeZone];
    notification.userInfo = @{@"key":@"key"};
    notification.alertBody=@"起床啦!!!!";
    notification.alertTitle = @"收到一条提醒";
    notification.repeatInterval= NSCalendarUnitMinute;//循环次数，kCFCalendarUnitWeekday一周一次,最小为NSCalendarUnitMinute.没分钟提示一次
    
    //这里不设置会没有声音
    notification.soundName =UILocalNotificationDefaultSoundName;
    notification.category = @"categoryOne";
    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
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
