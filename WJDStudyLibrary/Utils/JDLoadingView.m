//
//  JDLoadingView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDLoadingView.h"

static JDLoadingView *loadView;

@implementation JDLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAnimation];
    }
    return self;
}

- (void)createAnimation{

    //图标背景
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.bounds          = CGRectMake(0, 0, 100, 100);
    replicatorLayer.position        = self.center;
    replicatorLayer.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.1].CGColor;
    replicatorLayer.cornerRadius    = 10;
    replicatorLayer.masksToBounds   = YES;
    
    [self.layer addSublayer:replicatorLayer];
    
    //旋转图片
    UIImageView *imageView =[JDUtils createImageViewWithFrame:CGRectMake(0, 0, 50, 50) ImageName:@"loading"];
    imageView.center = self.center;
    [self addSubview:imageView];
    
    //旋转动画
    CABasicAnimation *rotationAnimZ = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimZ.beginTime = 0.0;
    rotationAnimZ.toValue = @(2*M_PI);
    rotationAnimZ.duration = 1;
    rotationAnimZ.repeatCount = INFINITY;
    [imageView.layer addAnimation:rotationAnimZ forKey:@"rotationAnimZ"];
}

+ (void)showView:(UIView *)view{

    loadView = [[JDLoadingView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    loadView.backgroundColor = [UIColor clearColor]; //背景的颜色
    loadView.center = view.center;
    [view addSubview:loadView];
}

+ (void)hide{
    
    if (loadView) {
        [loadView removeFromSuperview];
    }
}

@end
