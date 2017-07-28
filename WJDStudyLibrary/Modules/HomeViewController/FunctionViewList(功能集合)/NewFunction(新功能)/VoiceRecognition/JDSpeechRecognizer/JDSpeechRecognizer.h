//
//  JDSpeechRecognizer.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/28.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

//注意此类只适合IOS10之后的版本

#import <Foundation/Foundation.h>

typedef void(^Success)(NSString *result);
typedef void(^Failure)(NSError *error);

@interface JDSpeechRecognizer : NSObject


/**
 识别一个语音文件
 
 @param fileURL 识别的语音文件路径
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void)speechRecognizerWithVoiceFile:(NSURL *)fileURL success:(Success)success failure:(Failure)failure;

// 中文 zh-CN
// 英文 en-US
- (instancetype)initWithLocaleIdentifier:(NSString *)localeIdentifier;
- (void)startSpeechRecognizerWithResultBlock:(Success)callBack;
- (void)stopSpeechRecognizer;

@end
