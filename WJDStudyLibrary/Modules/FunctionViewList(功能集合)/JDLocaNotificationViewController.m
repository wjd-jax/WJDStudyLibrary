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
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:5];
    notification.timeZone=[NSTimeZone defaultTimeZone];
    notification.alertBody=@"起床啦!!!!";
    notification.alertTitle = @"收到一条提醒";
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
