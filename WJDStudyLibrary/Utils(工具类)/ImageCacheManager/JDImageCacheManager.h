//
//  JDImageCacheManager.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/11/1.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDImageCacheManager : NSObject


/**
 获取本地沙盒的一个图片,如果没有会进行下载

 @param imageUrl 图片url
 @return 本地沙盒image
 */
- (UIImage *)getImageCacheWithURLString:(NSString *)imageUrl;


+ (instancetype)shareInstance;

@end
