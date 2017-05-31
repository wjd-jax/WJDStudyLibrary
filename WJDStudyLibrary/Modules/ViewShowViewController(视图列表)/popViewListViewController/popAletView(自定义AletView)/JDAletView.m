//
//  JDAletView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//


#import "JDAletView.h"
@interface JDAletView ()

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *desc;

@end

@implementation JDAletView
{
    CGRect frame;
    UILabel *titleLabel;
    UILabel *descLabel;
    UIView *backView;
}
- (instancetype)initWithTitle:(NSString *)title detailMessage:(NSString *)desc callBack:(block)callBack
{
    self = [super init];
    if (self) {
        _callBack =callBack;
        _title =title;
        _desc =desc;
        frame =CGRectMake(0, 0, SCREEN_WIDHT/2, 180);
        self.frame =frame;
        self.clipsToBounds =YES;
        [self createUI];

        self.backgroundColor =[UIColor whiteColor];
      
    }
    return self;
}
- (void)createUI
{
    titleLabel =[JDUtils createLabelWithFrame:CGRectMake(0, 0, self.sizeWidth, self.sizeHeight/3) Font:14 Text:_title];
    titleLabel.textAlignment =NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UIView *lineView =[JDUtils createViewWithFrame:CGRectMake(20, self.sizeHeight/3, self.sizeWidth-40, 1)];
    lineView.backgroundColor =[UIColor grayColor];
    [self addSubview:lineView];
    
    descLabel =[JDUtils createLabelWithFrame:CGRectMake(0, titleLabel.sizeHeight, self.sizeWidth, self.sizeHeight/3) Font:12 Text:_desc];
    descLabel.textAlignment =NSTextAlignmentCenter;
    [self addSubview:descLabel];
    
    UIButton *button =[JDUtils createButtonWithFrame:CGRectMake(0, self.sizeHeight/3*2, self.sizeWidth, self.sizeHeight/3) ImageName:nil Target:self Action:@selector(button) Title:@"确定"];
    button.backgroundColor =[UIColor grayColor];
    [self addSubview:button];
    
}
- (void)button
{
    [self removeFromSuperview];
    [backView removeFromSuperview];
}
- (void)show
{
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    backView =[JDUtils createViewWithFrame:window.frame];
    backView.backgroundColor =[UIColor colorWithWhite:0.5 alpha:0.5];
    [window addSubview:backView];
    [window addSubview:self];
//    self.frame =CGRectZero;
    self.center =window.center;
//
//    //动画效果
//    [UIView animateWithDuration:0.5 animations:^{
//        self.frame =frame;
//        self.center =window.center;
//
//    }completion:^(BOOL finished) {
//       // [self createUI];
//    }];
}

@end
