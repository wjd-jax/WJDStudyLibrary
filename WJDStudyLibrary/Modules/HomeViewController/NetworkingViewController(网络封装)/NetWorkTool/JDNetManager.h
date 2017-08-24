//
//  JDNetManager.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
请求类型
 
 - RequestTypeGet:      get 类型
 - RequestTypePost:     post 类型
 - RequestTypeUpLoad:   上传类型
 - RequestTypeDownload: 下载类型
 */
typedef NS_ENUM(NSInteger,RequsetType){
    RequestTypeGet,
    RequestTypePost,
    RequestTypeUpLoad,
    RequestTypeDownload,
};

/**
 失败类型
 
 - ErroCode_NetNotReachable: 网络不可达
 - ErroCode_RequestFaiure:   请求数据失败
 - ErroCode_ErrorDataFormatRequst:    请求数据格式错误
 - ErroCode_DataStateError:   服务器返回失败状态
 */
typedef NS_ENUM(NSInteger,ErroCode){
    ErroCode_NetNotReachable,
    ErroCode_RequestFaiure,
    ErroCode_ErrorDataFormatRequst,
    ErroCode_DataStateError,
};

/**
 返回结果

 - request_faiure: 请求失败
 - request_success: 请求成功
 */
typedef NS_ENUM(NSInteger, RequestState){
    request_faiure,
    request_success,
    
};

typedef void (^SuccessBlock)(id requestData, NSDictionary *dataDict);
typedef void (^FailureBlock)(ErroCode code , NSString *msg);
typedef void (^LoadProgress)(float progress);

@interface JDNetManager : NSObject

/**
 Get 请求
 
 @param urlStr   url
 @param success  成功回调
 @param failure 失败回调
 */

+(void)getRequestUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parmeters success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 post 请求
 
 @param urlStr     请求的 url
 @param parameters post 参数
 @param success    成功回调
 @param failure    失败回调
 */
+(void)postRequestUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)openDebug;
+ (void)closeDebug;

@end
