//
//  JDDESUtil.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDDESUtil : NSObject
//加密方法
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
//解密方法
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key;
@end
