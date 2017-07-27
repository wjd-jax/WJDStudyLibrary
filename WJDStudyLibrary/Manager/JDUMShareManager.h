//
//  JDUMShareManager.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//



//==================================================
// 首先：配置第三方平台URL Scheme ->1->2->3->4
//==================================================

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

typedef NS_ENUM(NSInteger,ShareContentType){
    ShareContentTypeWeb = 1,//网页
    ShareContentTypeMusic,  //音乐
    ShareContentTypeVideo,  //视频
};

typedef void(^success)(id result);
typedef void(^failure)(NSError *error); //error.code 可以跟UMSocialPlatformErrorType比对.

@interface JDUMShareManager : NSObject

/**
 *  1.打开日志
 *
 *  @param isOpen YES代表打开，No代表关闭
 */
+ (void)openLog:(BOOL)isOpen;
/**
 *  2.设置友盟AppKey
 *
 *  @param UmSocialAppkey 友盟AppKey
 */
+ (void)setUmSocialAppkey:(NSString *)UmSocialAppkey;

/**
 *  3.设置平台的appkey
 *
 *  @param platform 平台类型 @see UMSocialPlatformType
 *  @param appKey       第三方平台的appKey（QQ平台为appID）
 *  @param appSecret    第三方平台的appSecret（QQ平台为appKey）
 *  @param redirectURL  redirectURL
 */
+ (BOOL)setPlatform:(UMSocialPlatformType)platform appKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL;

/**
 *  4.获得从sso或者web端回调到本app的回调 
 *  - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation >>
 *
 *  @param URL 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
+ (BOOL)handleOpenURL:(NSURL *)URL;

//==================================================
// 分享功能(适用自定义分享UI页面)
//==================================================

/**
 *  图文分享
 *
 *  @param platformType 平台类型 @see UMSocialPlatformType
 *  @param ContentText  文本(纯图可以为nil)
 *  @param thumbnail    缩略图
 *  @param shareImage   分享图片
 */
+ (void)shareGraphicToPlatformType:(UMSocialPlatformType)platformType
                      ContentText:(NSString *)ContentText
                        thumbnail:(id)thumbnail
                       shareImage:(id)shareImage
                          success:(success)success
                          failure:(failure)failure;
/**
 *  多媒体分享
 *
 *  @param platformType       平台类型 @see UMSocialPlatformType
 *  @param ShareContentType   分享多媒体类型 @see ShareContentType
 *  @param title              标题
 *  @param contentDescription 分享描述
 *  @param thumbnail          缩略图
 *  @param url                内容网页地址
 *  @param StreamUrl          数据流地址
 */
+ (void)shareMultimediaToPlatformType:(UMSocialPlatformType)platformType
                    ShareContentType:(ShareContentType)ShareContentType
                               title:(NSString *)title
                  contentDescription:(NSString *)contentDescription
                           thumbnail:(id)thumbnail
                                 url:(NSString *)url
                           StreamUrl:(NSString *)StreamUrl
                             success:(success)success
                             failure:(failure)failure;


@end
