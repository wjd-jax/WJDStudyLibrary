//
//  JDPrintLabel.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDPrintLabel.h"
#import <AudioToolbox/AudioToolbox.h>

@interface JDPrintLabel ()
{
    SystemSoundID  soundID;
    NSTimer *prientTimer;
}
@end

@implementation JDPrintLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor =[UIColor clearColor];
        self.hasSound =YES;
        self.time =0.3;
    }
    return self;
}

-(void)startPrint
{
    //播放声音
    NSString *path =[[NSBundle mainBundle] pathForResource:@"printerVoice" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &(soundID));
    
    prientTimer =    [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(outPutWord:) userInfo:nil repeats:YES];
}
-(void)outPutWord:(id)atimer
{
    if (self.text.length ==self.currentIndex) {
        
        [atimer invalidate];
        atimer =nil;
        DLog(@"打印完成");
        self.completeBlock();
    }
    else
    {
        DLog(@"正在打印");
        self.currentIndex ++;
        NSDictionary *dic =@{NSForegroundColorAttributeName:self.prientColor};
        NSMutableAttributedString *mutStr =[[NSMutableAttributedString alloc]initWithString:self.text];
        [mutStr addAttributes:dic range:NSMakeRange(0, self.currentIndex)];
        [self setAttributedText:mutStr];
        self.hasSound?AudioServicesPlaySystemSound(soundID):AudioServicesPlaySystemSound (0);
    }
}



-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [prientTimer invalidate];
    prientTimer =nil;
}
@end
