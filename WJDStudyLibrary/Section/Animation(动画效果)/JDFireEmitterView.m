//
//  JDFireEmitterView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDFireEmitterView.h"


@interface JDFireEmitterView ()
@property (nonatomic,retain) CAEmitterLayer *fireEmitter;   //发射器
@property (nonatomic,retain) UIImageView *candleImageView;  //蜡烛
@end

@implementation JDFireEmitterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor =[UIColor blackColor];
        [self createUI];
    }
    return self;
}
- (void)createUI {
    

    //初始化发射器
    _fireEmitter =[CAEmitterLayer layer];
    //fireEmitter.emitterSize = CGSizeMake(20, 60);
    
    // 发射器在xy平面的中心
    _fireEmitter.emitterPosition = self.center;
    
    //发射器形状
    _fireEmitter.emitterShape = kCAEmitterLayerCircle;
    
    //控制粒子的渲染模式,(比如是否粒子重叠加重色彩)默认值是kCAEmitterLayerUnordered
    _fireEmitter.renderMode =kCAEmitterLayerAdditive;
    
    //发射单元--火焰🔥
    CAEmitterCell *fire =[CAEmitterCell emitterCell];
    
    //粒子的创建速度,默认为1个每秒
    fire.birthRate =200;
    
    //粒子的存活时间
    fire.lifetime =0.2;
    
    //粒子的生存时间容差
    fire.lifetimeRange =0.5;
    
    //粒子的内容
    fire.color =[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1].CGColor;
    fire.contents = (id)[[UIImage imageNamed:@"DazFire.png"] CGImage];
    fire.name = @"fire";
    
    //粒子的速度
    fire.velocity =35;
    
    //粒子动画的速度容差
    fire.velocityRange =10;
    //粒子在 xy 平面的发射角度
    fire.emissionLongitude =M_PI+M_PI_2;
    
    // 粒子发射角度的容差
    fire.emissionRange = M_PI_2;
    // 缩放速度
    fire.scaleSpeed = 0.3;
    // 旋转度
    //    fire.spin = 0.2;
    
    _fireEmitter.emitterCells = @[fire];
    [self.layer addSublayer:_fireEmitter];
    

    
    

}

@end
