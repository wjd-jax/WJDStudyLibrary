//
//  JDFireworksView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/17.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDFireworksView.h"

@implementation JDFireworksView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    self.backgroundColor  = [UIColor blackColor];
    
    //cell产生在底部,向上移动
    CAEmitterLayer *fireworkdEmitter =[CAEmitterLayer layer];
    CGRect viewBounds = self.layer.bounds;
    
    fireworkdEmitter.emitterPosition =CGPointMake(viewBounds.size.width/2, viewBounds.size.height);
    fireworkdEmitter.emitterMode = kCAEmitterLayerOutline;
    fireworkdEmitter.emitterShape = kCAEmitterLayerLine;
    fireworkdEmitter.renderMode = kCAEmitterLayerAdditive;
    fireworkdEmitter.seed = (arc4random()%100)+1;
    
    //创建火箭cell
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];
    rocket.birthRate = 1;
    rocket.emissionRange = 0.25 *M_PI;
    rocket.velocity = 300;
    rocket.velocityRange = 75;
    rocket.lifetime =1.02;
    
    rocket.contents = (id)[UIImage imageNamed:@"DazFire"].CGImage;
    rocket.scale = 0.5;
    rocket.scaleRange =0.5;
    rocket.color = [UIColor redColor].CGColor;
    rocket.greenRange = 1.0;
    rocket.redRange = 1.0;
    rocket.blueRange = 1.0;
    rocket.spinRange =M_PI;
    
    //破裂对象不能被看到,但会产生火花
    //这里我们改变颜色,因为火花继承它的值
    CAEmitterCell *fireCell =[CAEmitterCell emitterCell];
    
    fireCell.birthRate          = 1;
    fireCell.velocity           = 0;
    fireCell.scale              = 1;
    fireCell.redSpeed           =- 1.5;
    fireCell.blueSpeed          =+ 1.5;
    fireCell.greenSpeed         =+ 1.5;        // shifting
    fireCell.lifetime           = 0.34;
    
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate            = 400;       //炸开后产生400个小烟花
    spark.velocity             = 125;       //速度
    spark.emissionRange        = 2* M_PI;   // 360 度
    spark.yAcceleration        = 40;         // 重力
    spark.lifetime             = 3;
    
    spark.contents          = (id) [[UIImage imageNamed:@"snow"] CGImage];
    spark.scaleSpeed        =- 0.2;
    
    spark.greenSpeed        =- 0.1;
    spark.redSpeed          =+ 0.1;
    spark.blueSpeed         =- 0.1;
    
    spark.alphaSpeed        =- 0.25;
    
    spark.spin              = 2* M_PI;
    spark.spinRange         = 2* M_PI;
    
    fireworkdEmitter.emitterCells        = [NSArray arrayWithObject:rocket];
    rocket.emitterCells                  = [NSArray arrayWithObject:fireCell];
    fireCell.emitterCells                = [NSArray arrayWithObject:spark];
    
    [self.layer addSublayer:fireworkdEmitter];
    
}

@end
