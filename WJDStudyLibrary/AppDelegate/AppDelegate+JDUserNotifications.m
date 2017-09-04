//
//  AppDelegate+JDUserNotifications.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/9.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "AppDelegate+JDUserNotifications.h"
#import <UserNotifications/UserNotifications.h>
@implementation AppDelegate (JDUserNotifications) //<UNUserNotificationCenterDelegate>

//Step 1 注册推送
- (void)registerUserNotification{
    
    UNUserNotificationCenter *center =[UNUserNotificationCenter currentNotificationCenter];
    //center.delegate = self;
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionSound |
     UNAuthorizationOptionAlert | UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
         
         if (error) {
             DLog(@"%@",error);
         }
     }];
    
    
}

#pragma mark - app在前台收到推送

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

#pragma mark - 处理用户点击推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSString *categoryIdentify = response.notification.request.content.categoryIdentifier;
    if ([categoryIdentify isEqualToString:@"closeCategory"]) {
        
        if ([response.actionIdentifier isEqualToString:@"closeAlarmIdentify"]) {
            //操作Identify
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
        }
    }
    completionHandler();
}

/*
 
 Step 2
 
 在需要的地方添加推送
 配置需要推送的content，UNMutableNotificationContent有很多属性，title，subtitle，sound，userInfo ...
 
 UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
 content.title = @"打卡";
 content.body = @"马上去打卡";
 content.badge = @1;
 content.sound = [UNNotificationSound soundNamed:@"4084.wav"];
 content.categoryIdentifier = @"closeCategory";
 
 如果需要执行操作可以进行如下配置
 
 UNNotificationAction *closeAction = [UNNotificationAction actionWithIdentifier:@"closeAlarmIdentify" title:@"关闭" options:UNNotificationActionOptionForeground];
 
 UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"closeCategory" actions:@[closeAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
 
 [center setNotificationCategories:[NSSet setWithArray:@[category]]];
 
 Step 3
 
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
 NSDateComponents 的weekday属性对应转换关系如下
 
 - (NSString *)getWeekDayWithIntegerDay:(NSInteger)weekday andSunDayType:(NSInteger)type
 {
 NSString* weekString;
 switch (weekday) {
 case 1:
 weekString = type?@"7":@"日";
 break;
 case 2:
 weekString = type?@"1":@"一";
 break;
 case 3:
 weekString = type?@"2":@"二";
 break;
 case 4:
 weekString = type?@"3":@"三";
 break;
 case 5:
 weekString = type?@"4":@"四";
 break;
 case 6:
 weekString = type?@"5":@"五";
 break;
 case 7:
 weekString = type?@"6":@"六";
 break;
 }
 
 return weekString
 }
 Step 4
 
 [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
 if (error) {
 NSLog(@"%@",error);
 }else
 {
 UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"添加成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
 
 [alertVC addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
 }]];
 
 [self presentViewController:alertVC animated:YES completion:nil];
 }
 }];
 */


@end
