//
//  JDMessageView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDMessageView.h"

@implementation JDMessageView

+ (void)showMessage:(NSString *)message
{
    
    JDDISPATCH_MAIN_THREAD(^{

        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [self showMessage:message withView:window];
        
    });
    
    
    
}
+(void)showMessage:(NSString *)message withView:(UIView *)view
{
    
    UIView *showView =[JDUtils createViewWithFrame:CGRectZero];
    showView.backgroundColor =[UIColor whiteColor];
    showView.alpha =0;
    JDViewSetRadius(showView, 5);
    [view addSubview:showView];

    
    //提示框的位置
    showView.frame = CGRectMake(0, -NavigationBar_HEIGHT, SCREEN_WIDHT, NavigationBar_HEIGHT+StatusBar_HEIGHT);
    UILabel *messageLabel =[JDUtils createLabelWithFrame:CGRectMake(0, StatusBar_HEIGHT, SCREEN_WIDHT, NavigationBar_HEIGHT) Font:14 Text:message];
    [showView addSubview:messageLabel];
    messageLabel.textAlignment =NSTextAlignmentCenter;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        showView.originY = 0;
        showView.alpha =1;
        
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            showView.sizeHeight =-NavigationBar_HEIGHT;
            showView.alpha =0;
            
        } completion:^(BOOL finished) {
            
            [showView removeFromSuperview];
        }];
    }];
    
}

@end
