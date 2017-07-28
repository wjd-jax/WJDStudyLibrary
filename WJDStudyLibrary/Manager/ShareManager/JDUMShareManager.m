//
//  JDUMShareManager.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//


#import "JDUMShareManager.h"


@implementation JDUMShareManager

//是否打开日志
+ (void)openLog:(BOOL)isOpen{
    [[UMSocialManager defaultManager] openLog:isOpen];
}

//设置appkey
+ (void)setUmSocialAppkey:(NSString *)UmSocialAppkey{
    [[UMSocialManager defaultManager] setUmSocialAppkey:UmSocialAppkey];
}

//设置平台AppKey
+ (BOOL)setPlatform:(UMSocialPlatformType)platform appKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL
{
    return [[UMSocialManager defaultManager] setPlaform:platform appKey:appKey appSecret:appSecret redirectURL:redirectURL];
}
//回调的url
+(BOOL)handleOpenURL:(NSURL *)URL
{
    return [[UMSocialManager defaultManager] handleOpenURL:URL];
}

//图文分享
+ (void)shareGraphicToPlatformType:(UMSocialPlatformType)platformType
                      ContentText:(NSString *)ContentText
                        thumbnail:(id)thumbnail
                       shareImage:(id)shareImage
                          success:(success)success
                          failure:(failure)failure
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    ContentText ? (messageObject.text = ContentText) : nil;
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumbnail;
    [shareObject setShareImage:shareImage];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            failure(error); //error.code ==2009 分享取消 else 分享失败 @see UMSocialPlatformErrorType

        }else{
            success(data);  //UMSocialShareResponse
        }
    }];
}

//多媒体分享
+ (void)shareMultimediaToPlatformType:(UMSocialPlatformType)platformType
                    ShareContentType:(ShareContentType)ShareContentType
                               title:(NSString *)title
                  contentDescription:(NSString *)contentDescription
                           thumbnail:(id)thumbnail
                                 url:(NSString *)url
                           StreamUrl:(NSString *)StreamUrl
                             success:(success)success
                             failure:(failure)failure
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    switch (ShareContentType) {
        case ShareContentTypeWeb:{
            
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:contentDescription thumImage:thumbnail];
            shareObject.webpageUrl = url;
            messageObject.shareObject = shareObject;
        }
            break;
        case ShareContentTypeMusic:{
            
            UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:contentDescription thumImage:thumbnail];
            shareObject.musicUrl = url;
            shareObject.musicDataUrl = StreamUrl;
            messageObject.shareObject = shareObject;
        }
            break;
        case ShareContentTypeVideo:{
            
            UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:contentDescription thumImage:thumbnail];
            shareObject.videoUrl = url;
            shareObject.videoStreamUrl = StreamUrl;
            messageObject.shareObject = shareObject;
        }
            break;
        default:
            break;
    }
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            failure(error); //error.code ==2009 分享取消 else 分享失败
        }else{
            success(data);  //UMSocialShareResponse
        }
    }];
}

@end
