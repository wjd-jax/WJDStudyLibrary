//
//  JDContactManager.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/26.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDContactManager : NSObject

/**
 创建单例

 @return 返回单例
 */
+ (instancetype)manager;

- (void)presentContactUIWithViewController:(UIViewController *)vc;

@end
