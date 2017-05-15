//
//  JDHeadView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDHeadView.h"

@implementation JDHeadView


- (void)drawRect:(CGRect)rect {
    
    
    
    // Drawing code
    // 初始化UIBezierPath
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 首先设置一个起始点
    
    /////左半边曲线
    CGPoint startPoint = CGPointMake(rect.size.width/2,  rect.size.height*0.4);
    // 以起始点为路径的起点
    [path moveToPoint:startPoint];
    // 设置一个终点
    CGPoint endPoint = CGPointMake(rect.size.width/2, rect.size.height- rect.size.height*0.1);
    
    // 设置第一个控制点
    CGPoint controlPoint1 = CGPointMake(self.bounds.size.width*0.1, rect.size.height*0.1);
    // 设置第二个控制点
    CGPoint controlPoint2 = CGPointMake(0, self.size.height*0.7);
    // 添加三次贝塞尔曲线
    [path addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    // 设置另一个起始点
    [path moveToPoint:endPoint];
    
    //右半边曲线>>>>>>>>>>>>>>>>>>>>
    // 设置第三个控制点
    CGPoint controlPoint3 = CGPointMake(rect.size.width-self.bounds.size.width*0.1,  rect.size.height*0.1);
    // 设置第四个控制点
    CGPoint controlPoint4 = CGPointMake(rect.size.width, self.size.height*0.7);
    // 添加三次贝塞尔曲线
    [path addCurveToPoint:startPoint controlPoint1:controlPoint4 controlPoint2:controlPoint3];
    // 设置线宽
    path.lineWidth = 3;
    // 设置线断面类型
    path.lineCapStyle = kCGLineCapRound;
    // 设置连接类型
    path.lineJoinStyle = kCGLineJoinRound;
    // 设置画笔颜色
    [[UIColor redColor] set];
    
    [path stroke];
    
    
    UIView *heart = [[UIView alloc] init];
    heart.frame = CGRectMake(0, 0, 20 , 20);
    heart.backgroundColor =[UIColor redColor];
    [self addSubview:heart];
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 设置动画的路径为心形路径
    animation.path = path.CGPath;
    // 动画时间间隔
    animation.duration = 3.0f;
    // 重复次数为最大值
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    //设置加速度
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 将动画添加到动画视图上
    [heart.layer addAnimation:animation forKey:nil];

}


@end
