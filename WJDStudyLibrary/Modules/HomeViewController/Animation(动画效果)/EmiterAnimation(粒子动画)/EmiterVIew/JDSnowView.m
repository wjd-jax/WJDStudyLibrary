//
//  JDSnowView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/17.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDSnowView.h"

@implementation JDSnowView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.backgroundColor  = [UIColor blackColor];
    // 创建粒子Layer
    CAEmitterLayer *snowEmitter = [CAEmitterLayer layer];
    // 粒子发射位置
    snowEmitter.emitterPosition = CGPointMake(self.sizeWidth/2,20);
    // 发射源的尺寸大小
    snowEmitter.emitterSize = self.bounds.size;
    // 发射模式
    snowEmitter.emitterMode = kCAEmitterLayerSurface;
    // 发射源的形状
    snowEmitter.emitterShape = kCAEmitterLayerLine;
    // 创建雪花类型的粒子
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    // 粒子的名字
    snowflake.name = @"snow";
    // 粒子参数的速度乘数因子
    snowflake.birthRate = 100.0;  //每秒生成数量
    snowflake.lifetime = 60;        //生存时间
    // 粒子速度
    snowflake.velocity =10.0;
    // 粒子的速度范围
    snowflake.velocityRange = 10;
    // 粒子y方向的加速度分量
    snowflake.yAcceleration = 8;
    // 周围发射角度
    snowflake.emissionRange = 0.5 * M_PI;
    // 子旋转角度范围
    snowflake.spinRange = 0.25 * M_PI;
    snowflake.contents = (id)[[UIImage imageNamed:@"snow"] CGImage];
    // 设置雪花形状的粒子的颜色
    snowflake.color = [[UIColor whiteColor] CGColor];
    //缩放范围
    snowflake.scaleRange = 0.3f;
    snowflake.scale = 0.1f;
    
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius = 0.0;
    snowEmitter.shadowOffset = CGSizeMake(0.0, 0.0);
    // 粒子边缘的颜色
    snowEmitter.shadowColor = [[UIColor whiteColor] CGColor];    
    // 添加粒子
    snowEmitter.emitterCells = @[snowflake];
    
    // 将粒子Layer添加进图层中
    [self.layer addSublayer:snowEmitter];}


@end
