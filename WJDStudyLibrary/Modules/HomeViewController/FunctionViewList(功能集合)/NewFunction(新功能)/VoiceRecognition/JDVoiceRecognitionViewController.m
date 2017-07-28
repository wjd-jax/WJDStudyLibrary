//
//  JDVoiceRecognitionViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/28.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDVoiceRecognitionViewController.h"
#import "JDAuthorityManager.h"
#import "JDSpeechRecognizer.h"

@implementation JDVoiceRecognitionViewController
{
    UITextView *textView;
    JDSpeechRecognizer *speedRecpgnizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    textView =[[UITextView alloc]initWithFrame:CGRectMake(10, 70, SCREEN_WIDHT-20, 300)];
    textView.backgroundColor = JDCOLOR_FROM_RGB_OxFF_ALPHA(0xd1efd6, 0.5);
    textView.font =[UIFont systemFontOfSize:18];
    [self.view addSubview:textView];
    

    
    UIButton *button =[JDUtils createSystemButtonWithFrame:CGRectMake(30, CGRectGetMaxY(textView.frame)+10, 100, 30) Target:self Action:@selector(fileRecd) Title:@"识别语音文件"];
    [self.view addSubview:button];
    
    UIButton *voiceButton =[UIButton buttonWithType:UIButtonTypeSystem];
    [voiceButton setTitle:@"长按录音,松开结束" forState:UIControlStateNormal];
    [voiceButton setTitle:@"松手结束" forState:UIControlStateHighlighted];
    voiceButton.frame = CGRectMake(0, 0, 200, 70);
    voiceButton.center = CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT-100);
    voiceButton.backgroundColor = JDCOLOR_FROM_RGB_OxFF_ALPHA(0xd1efd6, 1);
    [voiceButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [voiceButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];    [self.view addSubview:voiceButton];
}

-(void)touchDown:(UIButton *)button
{
    DLog(@"长按触发");
    speedRecpgnizer =[[JDSpeechRecognizer alloc]initWithLocaleIdentifier:@"zh-CN"];
   
    [speedRecpgnizer startSpeechRecognizerWithResultBlock:^(NSString *result) {
        textView.text = result;
    }];
    
}


-(void)touchUpInside:(UIButton *)button
{
    DLog(@"长按结束");
    [speedRecpgnizer stopSpeechRecognizer];
}

- (void)fileRecd {
    
    if ([JDAuthorityManager isObtainSpeechRecognizer]) {
        [JDMessageView showMessage:@"语音已经授权"];
    }
    else
    {
        [JDAuthorityManager obtainSFSpeechAuthorizedStatus];
        return;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp3"];
    if (!url) {
        [JDMessageView showMessage:@"文件不存在"];
        return;
    }
    [JDSpeechRecognizer speechRecognizerWithVoiceFile:url success:^(NSString *result) {
        textView.text = result;

    } failure:^(NSError *error) {
        [JDMessageView showMessage:@"识别失败"];
    }];
}

@end
