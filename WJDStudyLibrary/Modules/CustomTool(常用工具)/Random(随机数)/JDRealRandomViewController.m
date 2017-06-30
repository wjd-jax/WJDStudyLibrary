//
//  JDRealRandomViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/1.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDRealRandomViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface JDRealRandomViewController ()

{
    AVAudioRecorder *recorder ;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UILabel *randomLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhongziLabel;
@property (assign,nonatomic) CGPoint point;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (assign,nonatomic) float voiceLevel;

@end

@implementation JDRealRandomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startAvA];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [timer invalidate];
}
- (void)startAvA{
    
    
    /* 必须添加这句话，否则在模拟器可以，在真机上获取始终是0  */
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    
    /* 不需要保存录音文件 */
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorder)
    {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        
    }
    else
    {
        NSLog(@"%@", [error description]);
    }
}

/* 该方法确实会随环境音量变化而变化，但具体分贝值是否准确暂时没有研究 */
- (void)levelTimerCallback {
    [recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    _voiceLevel = level *10000;
    
}

- (IBAction)moreClick:(id)sender {
    
    timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(randomClick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    
    
}

- (IBAction)randomClick:(id)sender {
    
    
    [self levelTimerCallback];
    int a = _voiceLevel;
    _zhongziLabel.text = [NSString stringWithFormat:@"种子:%@",@(a)];
    srandom(a);
    int i = random() % 10000;
    _randomLabel.text = [NSString stringWithFormat:@"%@",@(i)];
    
    [self levelTimerCallback];
    int b = _voiceLevel;
    _zhongziLabel.text = [NSString stringWithFormat:@"种子:%@",@(b)];
    srandom(a);
    int i2 = random() % 100;
    _randomLabel.text = [NSString stringWithFormat:@"%@",@(i2)];
    _point = CGPointMake(i/10000.0*_bgView.sizeWidth, i2/100.0*_bgView.sizeHeight);
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(_point.x, _point.y, 2, 2)];
    view.backgroundColor =[UIColor redColor];
    JDViewSetRadius(view, 1);
    DLog(@">>>%@,%@",@(_point.x),@(_point.y));
    
    [_bgView addSubview:view];
    
    
    
}



@end
