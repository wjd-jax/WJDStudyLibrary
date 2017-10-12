//
//  JDHubMessageView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/10/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDHubMessageView.h"

@implementation JDHubMessageView

#define font_size 14

+(void)showMessage:(NSString *)message withView:(UIView *)view
{
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = JDRGBColor(0, 0, 0, 0.8);
    showview.frame = CGRectZero;
    
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [view addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    //CGSize labelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:font_size]};
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(290, 9000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    label.frame = CGRectMake(10, 5, labelSize.width, labelSize.height);
    label.text = message;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:font_size];
    [showview addSubview:label];
    //提示框的位置
    showview.frame = CGRectMake(0, 0, labelSize.width+21*2, labelSize.height+21*2);
    showview.center =CGPointMake(SCREEN_WIDHT/2, SCREEN_HEIGHT/2);
    label.center = CGPointMake(showview.frame.size.width/2, showview.frame.size.height/2);
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        showview.alpha = 0;

    } completion:^(BOOL finished) {
        [showview removeFromSuperview];

    }];
    
}

+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [JDHubMessageView showMessage:message withView:window];
}

@end
