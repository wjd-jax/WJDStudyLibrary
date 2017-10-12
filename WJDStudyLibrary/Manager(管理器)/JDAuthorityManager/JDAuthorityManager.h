//
//  JDAuthorityManager.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDAuthorityManager : NSObject

#pragma mark - 请求所有权限

/**
 一次性请求 APP 所有需要的权限
 */
+ (void)requestAllAuthority;


#pragma mark - 定位

/**
 * @brief 是否开启定位权限
 */
+ (BOOL)isObtainLocationAuthority;
+ (void)obtainCLLocationAlwaysAuthorizedStatus; //始终访问位置信息
+ (void)obtainCLLocationWhenInUseAuthorizedStatus; //使用时访问位置信息

#pragma mark - 推送

+ (void)obtainUserNotificationAuthorizedStatus;


#pragma mark - 媒体资料库
/**
 * @brief 是否开启媒体资料库权限
 */
+ (BOOL)isObtainMediaAuthority;
+ (void)obtainMPMediaAuthorizedStatus;

#pragma mark - 语音识别
/**
 * @brief 是否开启语音识别权限
 */
+ (BOOL)isObtainSpeechAuthority;
+ (void)obtainSFSpeechAuthorizedStatus;

#pragma mark - 日历权限
/**
 * @brief 是否开启日历权限
 */
+ (BOOL)isObtainEKEventAuthority;
+ (void)obtainEKEventAuthorizedStatus; //开启日历权限

#pragma mark - 相册权限
/**
 * @brief 是否开启相册权限
 */
+ (BOOL)isObtainPhPhotoAuthority;
+ (void)obtainPHPhotoAuthorizedStaus; //开启相册权限

#pragma mark - 相机权限
/**
 * @brief 是否开启相机权限
 */
+ (BOOL)isObtainAVVideoAuthority;
+ (void)obtainAVMediaVideoAuthorizedStatus;

#pragma mark - 通讯录权限
/**
 * @brief 是否开启通讯录权限
 */
+ (BOOL)isObtainCNContactAuthority;
+ (void)obtainCNContactAuthorizedStatus;

#pragma mark - 麦克风权限
/**
 * @brief 是否开启麦克风权限
 */
+ (BOOL)isObtainAVAudioAuthority;
+ (void)obtainAVMediaAudioAuthorizedStatus;

#pragma mark - 提醒事项权限
/**
 * @brief 是否开启提醒事项权限
 */
+ (BOOL)isObtainReminder;
+ (void)obtainEKReminderAuthorizedStatus;

#pragma mark - 运动与健身
/**
 * @brief 开启运动与健身权限(需要的运动权限自己再加,目前仅有"步数"、"步行+跑步距离"、"心率")
 */
+ (void)obtainHKHealthAuthorizedStatus;

#pragma mark - 语音识别项权限
/**
 * @brief 是否开启语音识别事项权限
 */
+ (BOOL)isObtainSpeechRecognizer;
+ (void)obtainSpeechRecognizeAuthorizedStatus;
@end
