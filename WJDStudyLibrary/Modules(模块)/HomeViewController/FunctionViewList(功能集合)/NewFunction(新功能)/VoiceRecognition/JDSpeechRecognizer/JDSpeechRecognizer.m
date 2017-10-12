//
//  JDSpeechRecognizer.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/28.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDSpeechRecognizer.h"
#import <Speech/Speech.h>

@interface JDSpeechRecognizer ()

@property(nonatomic,strong)AVAudioEngine *audioEngine;//语音引擎,负责提供语音输入
@property(nonatomic,strong)SFSpeechRecognizer *speechRecognizer;//语音识别器
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest *speechRequest;//处理语音识别请求
@property(nonatomic,strong)SFSpeechRecognitionTask *recognitionTask;//输入语音识别对象的结果
@property(nonatomic,strong)NSLocale *locale;//语言类型

@end

@implementation JDSpeechRecognizer


/**
 识别一个语音文件
 
 @param fileURL 识别的语音文件路径
 */
+ (void)speechRecognizerWithVoiceFile:(NSURL *)fileURL success:(Success)success failure:(Failure)failure{
    
    //初始化一个识别器
    SFSpeechRecognizer *recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    
    //初始化一个识别的请求
    SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:fileURL];
    
    //发起请求,注意会返回好多次
    [recognizer recognitionTaskWithRequest:request resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if(error)
        {
            failure(error);
        }
        else
        {
            success(result.bestTranscription.formattedString);
        }
    }];
}
// 中文 zh-CN
// 英文 en-US
#pragma mark - init
- (instancetype)initWithLocaleIdentifier:(NSString *)localeIdentifier
{
    self = [super init];
    if (self) {
        self.locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    }
    return self;
}

- (void)startSpeechRecognizerWithResultBlock:(Success)callBack{
    
    [self.audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:[self.audioEngine.inputNode outputFormatForBus:0] block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        //为语音识别请求添加一个AudioPCMbuffer,来获取声音数据
        [self.speechRequest appendAudioPCMBuffer:buffer];
    }];
    
    [self.audioEngine prepare];
    
    NSError *error;
    // 启动声音处理器
    [self.audioEngine startAndReturnError: &error];
    [self.speechRecognizer recognitionTaskWithRequest:self.speechRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result,NSError * _Nullable error)
     {
         // 识别结果，识别后的操作
         if (result == NULL) return;
         callBack(result.bestTranscription.formattedString);
     }];
}

- (void)stopSpeechRecognizer{
    
    // 停止声音处理器，停止语音识别请求进程
    [[self.audioEngine inputNode] removeTapOnBus:0];
    [self.audioEngine stop];
    [self.speechRequest endAudio];
    self.speechRequest = nil;
    self.recognitionTask = nil;
}

- (void)dealloc
{
    DLog(@"语音识别释放");//并没有释放
}

#pragma mark - lazy
- (AVAudioEngine *)audioEngine
{
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc]init];
    }
    return _audioEngine;
}

- (SFSpeechRecognizer *)speechRecognizer
{
    if (!_speechRecognizer) {
        _speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:self.locale];
    }
    return _speechRecognizer;
}

-(SFSpeechAudioBufferRecognitionRequest *)speechRequest
{
    if (!_speechRequest) {
        _speechRequest =[[SFSpeechAudioBufferRecognitionRequest alloc]init];
        _speechRequest.shouldReportPartialResults = YES;//是否是实时返回结果
    }
    return _speechRequest;
}
@end
