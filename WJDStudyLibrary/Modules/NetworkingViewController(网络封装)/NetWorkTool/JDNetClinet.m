//
//  JDNetCLinet.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDNetClinet.h"



@implementation JDNetClinet

//@synthesize debug;

+ (instancetype)sharedClient
{
    static JDNetClinet *_shareClient =nil;
    JDDISPATCH_ONCE_BLOCK((^{
        _shareClient =[[JDNetClinet alloc]initWithBaseURL:[NSURL URLWithString:BASEURL]];
        
        //设置可以接受格式
        _shareClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
        //移除 NULL 值
        ((AFJSONResponseSerializer *)_shareClient.responseSerializer).removesKeysWithNullValues = YES;
        //证书相关(这里有的时候设置了之后,后台会拿不到参数,如果出现,删除下列设置证书语句)
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        _shareClient.securityPolicy = securityPolicy;
        //超时时间
        _shareClient.requestSerializer.timeoutInterval =10;
        //设置返回格式
        _shareClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }));
    
    return _shareClient;
    
}
@end
