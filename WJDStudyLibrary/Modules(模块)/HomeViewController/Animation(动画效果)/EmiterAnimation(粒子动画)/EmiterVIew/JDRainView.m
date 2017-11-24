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
    
    self.backgroundColor =[UIColor clearColor];
    //发射器
    CAEmitterLayer *rainEmitter =[CAEmitterLayer layer];
    
    rainEmitter.emitterShape    = kCAEmitterLayerLine;
    rainEmitter.emitterMode     = kCAEmitterLayerOutline;
    rainEmitter.emitterSize     = self.bounds.size;
    rainEmitter.renderMode      = kCAEmitterLayerAdditive;
    rainEmitter.emitterPosition = CGPointMake(self.sizeWidth/2, 20);
    //水滴
    CAEmitterCell *rainflake    = [CAEmitterCell emitterCell];
    rainflake.birthRate         = 24;       //每秒发出的数量
    rainflake.velocity          = 0;      //加速度
    rainflake.yAcceleration     = 200;      //重力
    rainflake.contents          = (id)[UIImage imageNamed:@"rain"].CGImage;
    rainflake.color             = JDRGBColor(0, 0, 0, 0.05).CGColor;
    rainflake.alphaSpeed        =+ 0.1;
    
    rainflake.lifetime          = 2.3;        //生命周期
    rainflake.scale             = 0.5;      //缩放
    rainflake.scaleRange        = 0.2;
    rainflake.emissionLongitude = -M_PI/6;
    
    rainEmitter.emitterCells    = @[rainflake];

    [self.layer addSublayer:rainEmitter];
}


@end
