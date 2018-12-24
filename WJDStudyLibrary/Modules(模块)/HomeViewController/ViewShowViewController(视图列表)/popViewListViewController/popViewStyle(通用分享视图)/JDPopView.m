//
//  JDPopView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDPopView.h"
@interface JDPopView ()

@property (nonatomic, strong) UIView *backView;

@end

@implementation JDPopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, KSCREEN_HEIGHT, KSCREEN_WIDTH, KSCREEN_HEIGHT / 2);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showWithBlock:(callBackBlock)block
{
    _callblock = block;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _backView = [JDUIFactory createViewWithFrame:window.frame];
    _backView.backgroundColor = JDRGBAColor(0, 0, 0, 0.5);
    _backView.alpha = 0;
    [_backView addSubview:self];

    [window addSubview:_backView];

    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       self.originY = KSCREEN_HEIGHT / 2;
                       _backView.alpha = 1;
                     }
                     completion:^(BOOL finished){

                     }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_backView addGestureRecognizer:tap];
}

- (void)tap2
{
    _callblock(@"点击弹出视图区域");
}

- (void)tap
{
    DLog(@"取消弹出视图");
    [UIView animateWithDuration:0.5
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{

          self.originY = KSCREEN_HEIGHT;
          _backView.alpha = 0;

        }
        completion:^(BOOL finished) {

          [_backView removeFromSuperview];
          [self removeFromSuperview];
        }];
}

@end
