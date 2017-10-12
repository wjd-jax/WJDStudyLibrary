//
//  JDRainView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/18.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDRainView.h"

@implementation JDRainView


- (void)drawRect:(CGRect)rect {
    
    self.backgroundColor =[UIColor whiteColor];
    //发射器
    CAEmitterLayer *rainEmitter =[CAEmitterLayer layer];
    
    rainEmitter.emitterShape    = kCAEmitterLayerLine;
    rainEmitter.emitterMode     = kCAEmitterLayerOutline;
    rainEmitter.emitterSize     = self.bounds.size;
    rainEmitter.renderMode      = kCAEmitterLayerAdditive;
    rainEmitter.emitterPosition = CGPointMake(self.sizeWidth/2, 20);
    //水滴
    CAEmitterCell *rainflake    = [CAEmitterCell emitterCell];
    rainflake.birthRate         = 50;   //每秒发出的数量

    //rainflake.speed             = 10;   //速度
    rainflake.velocity          = 0;   //加速度
    //rainflake.velocityRange     = 75;   //加速度范围
    rainflake.yAcceleration     = 200;  //重力
    
    rainflake.contents          = (id)[UIImage imageNamed:@"rain"].CGImage;
    rainflake.color             = [UIColor whiteColor].CGColor;
    rainflake.lifetime          = 2;   //生命周期
    rainflake.scale             = 0.3;  //缩放
    rainflake.scaleRange        = 0.2;
    
    rainEmitter.emitterCells    = @[rainflake];

    [self.layer addSublayer:rainEmitter];
}


@end
