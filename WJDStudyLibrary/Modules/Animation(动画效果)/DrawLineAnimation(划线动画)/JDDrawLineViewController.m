//
//  JDDrawLineViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDDrawLineViewController.h"

@interface JDDrawLineViewController ()

@end

@implementation JDDrawLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //绘制圆角的区域
    UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 100, 300, 300) cornerRadius:150];
    
    CAShapeLayer *shapeLayer =[[CAShapeLayer alloc]init];
    //边框颜色
    shapeLayer.strokeColor =[UIColor redColor].CGColor;
    //填充颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth =5;
    
    shapeLayer.lineJoin =kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
    
    //添加动画
    CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnim.duration = 5;
    pathAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnim.fromValue = @0;
    pathAnim.toValue = @1;
    pathAnim.removedOnCompletion = NO;
//    pathAnim.autoreverses = YES;
    pathAnim.fillMode = kCAFillModeForwards;
    pathAnim.repeatCount = INFINITY;
    [shapeLayer addAnimation:pathAnim forKey:@"strokeEndAnim"];

    

}


@end
