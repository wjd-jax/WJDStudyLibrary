//
//  JDNetManager.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDNetManager.h"
#import "Reachability.h"
#import "JDNetClinet.h"

NSString *const badNet = @"网络错误";
NSString *const requestFail = @"数据请求失败";
NSString *const requestDataStateError = @"服务器返回失败状态";

@interface JDNetManager ()

@end

@implementation JDNetManager

+ (BOOL)isConnection
{
    return [[self alloc] isConnectionAvailable];
}

/**
 *  网络判断
 *
 *  @return 是否可以联网
 */
- (BOOL)isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:                      //无网络(无法判断内外网)
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:                  //WIFI
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:                  //流量
            isExistenceNetwork = YES;
            break;
    }
    
    return isExistenceNetwork;
}


+(void)getRequestUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parmeters success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    [[self alloc] requestWithURL:urlStr WithDict:parmeters requestType:RequestTypeGet imageKey:nil withData:nil upLoadProgress:nil success:^(id requestData,NSDictionary *dataDict) {
        
        success(requestData,dataDict);
        
    } failure:^(ErroCode code, NSString *msg) {
        
        failure(code,msg);
        
    }];
}

+(void)postRequestUrlStr:(NSString *)urlStr withDic:(NSDictionary *)parameters success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    [[self alloc] requestWithURL:urlStr WithDict:parameters requestType:RequestTypePost imageKey:nil withData:nil upLoadProgress:nil success:^(id requestData,NSDictionary *dataDict) {
        
        success(requestData,dataDict);
        
    } failure:^(ErroCode code, NSString *msg) {
        
        failure(code,msg);
        
    }];
    
}

#pragma mark - 网络统一处理
- (void)requestWithURL:(NSString *)url WithDict:(NSDictionary *)parameters requestType:(RequsetType)type imageKey:(NSString *)attach withData:(NSData *)data upLoadProgress:(LoadProgress)loadProgress success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if (![self isConnectionAvailable]) {
        
        failure(ErroCode_NetNotReachable,badNet);
        
        if ([self DeBug])DLog(@"错误状态%@---%@",@(ErroCode_NetNotReachable),badNet);
        
        return;
    }
    //url出现特殊字符处理
    url =[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    JDNetClinet *client =[JDNetClinet sharedClient];
    //通用参数处理,这里可以添加所有接口通用的参数
    parameters = [self dealParrameters:parameters];
    
    if ([self DeBug])DLog(@"参数列表%@",parameters);
    
    switch (type) {
            
        case RequestTypeGet:
        {
            if ([self DeBug])DLog(@"请求的 URL---%@",url);

            [client GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self returnDataWithRequestData:responseObject Success:^(id requestData, NSDictionary *dataDict) {
                    success(requestData,dataDict);
                    
                } failure:^(ErroCode code, NSString *msg) {
                    failure(ErroCode_RequestFaiure,requestFail);
                    
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failure(ErroCode_RequestFaiure,requestFail);
                if ([self DeBug])DLog(@"错误状态%@---%@",@(ErroCode_RequestFaiure),requestFail);
                
            }];
        }
            break;
        case RequestTypePost:
        {
            if ([self DeBug])DLog(@"请求的 URL---%@%@",BASEURL,url);

            [client POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [self returnDataWithRequestData:responseObject Success:^(id requestData, NSDictionary *dataDict) {
                    success(requestData,dataDict);
                    
                } failure:^(ErroCode code, NSString *msg) {
                    failure(ErroCode_RequestFaiure,requestFail);
                    
                }];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                if ([self DeBug])DLog(@"错误状态%@---%@",@(ErroCode_RequestFaiure),requestFail);
                failure(ErroCode_RequestFaiure,requestFail);
            }];
        }
            break;
        default:
            break;
    }
    
}

/**
 返回的数据统一处理
 */
- (void)returnDataWithRequestData:(NSData *)requestData Success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    id resultData =[NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingMutableContainers error:nil];
    //先判断是不是字典类型如果是,则添加通用处理方法,处理字典最外层数据基本的成功失败
    if ([resultData isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *requestDatat =(NSDictionary *)resultData;
        
        BOOL state = YES;       //APP 接口约定的返回数据成功或者失败的标志,比如requestDatat[@"state"]
//        errMsg = "<null>";
//        reLogin = 0;
//        success = 1;
        if (state) {
            //如果服务器返回的状态是成功则返回需要处理的数据,除去最外层的状态字段,比如requestDatat[@"result"]
            success(resultData,requestDatat);
            if ([self DeBug])DLog(@"返回结果%@",resultData);
            
        }
        else
        {
            //如果服务器返回的状态是失败,则告诉调用者返回失败,
            failure(ErroCode_DataStateError,requestDataStateError);
            if ([self DeBug])DLog(@"错误状态%@---%@",@(ErroCode_DataStateError),requestDataStateError);
            
        }
    }
    //如果不是字典类型的数据,则直接返回数据原型,如果 APP 正常 API 都是字典类型的话,这里最好有一个警告,否则可能引起调用端无法处理数据
    //更新,添加了成功回调的参数,如果非字典类型,则返回的字典为 nil
    else
    {
        success(resultData,nil);
        if ([self DeBug])DLog(@"返回结果%@",resultData);
    }
    //如果开启 debug 模式,则关闭
    if ([self DeBug]) {
        
        [JDNetClinet sharedClient].debug =NO;
    }
}

/**
 此方法处理上传的通用参数
 
 @param parameters 接口请求的参数
 */
- (NSDictionary *)dealParrameters:(NSDictionary *)parameters
{
    return parameters;
}

/**
 开启调试模式
 */
+ (void)openDebug
{
    [JDNetClinet sharedClient].debug =YES;
}
+ (void)closeDebug
{
    [JDNetClinet sharedClient].debug =NO;
}

/**
 判断是否开启调试模式
 
 @return 调试模式的状态
 
 */
- (BOOL)DeBug
{
    return [JDNetClinet sharedClient].debug;
}

@end
