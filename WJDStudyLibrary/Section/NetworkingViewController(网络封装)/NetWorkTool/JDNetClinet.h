//
//  JDNetCLinet.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


/**
 此方法设置测试跟正式服务器的 baseurl
 */

#if DEBUG

static NSString* const BASEURL = @"";

#else

static NSString* const BASEURL = @"";

#endif

@interface JDNetClinet : AFHTTPSessionManager

/**
 调试模式,如果开启,则打印请求的链接,参数以及各种错误日志
 */
@property(nonatomic,assign)BOOL debug;

+ (instancetype)sharedClient;

@end
