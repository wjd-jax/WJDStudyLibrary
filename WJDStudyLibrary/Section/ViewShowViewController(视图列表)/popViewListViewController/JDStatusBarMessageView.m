//
//  JDStatusBarMessageView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/22.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDStatusBarMessageView.h"

@implementation JDStatusBarMessageView

+ (void)showMessage:(NSString *)message
{
    
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    window.windowLevel = UIWindowLevelStatusBar;
    [self showMessage:message withView:window];
    
    
}
+(void)showMessage:(NSString *)message withView:(UIView *)view
{
    
    UIView *showView =[JDUtils createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, StatusBar_HEIGHT)];
    showView.backgroundColor =[UIColor blueColor];
    showView.tag =10000;
    [view addSubview:showView];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayMethod) userInfo:nil repeats:YES];
    [timer fire];
    
    UILabel *messageLabel =[JDUtils createLabelWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, StatusBar_HEIGHT) Font:12 Text:message];
    messageLabel.textAlignment =NSTextAlignmentCenter;
    messageLabel.font =[UIFont boldSystemFontOfSize:12];
    [showView addSubview:messageLabel];
    
    
    [UIView animateWithDuration:0.1 delay:2 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        showView.alpha =0;
        
    } completion:^(BOOL finished) {
        [timer invalidate];
        
        int count =0;
        for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
            if (view.tag ==10000) {
                count++;
            }
        }
        if (count ==1) {
            [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelNormal;
        }
        [showView removeFromSuperview];
        
    }];
    
}
+ (void)delayMethod
{
    for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
        if (view.tag ==10000) {
            view.backgroundColor =[UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:0.6];
            
        }
    }
    
}


@end
