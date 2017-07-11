//
//  JDWaterWaveView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDWaterWaveView.h"

@interface JDWaterWaveView ()

/**
 位移
 */
@property(nonatomic,assign)CGFloat offsetX;
/**
 当前波浪高度
 */
@property(nonatomic,assign)CGFloat currentK;

/**
 波浪宽度
 */
@property(nonatomic,assign)CGFloat waterWaveWidth;

@property(nonatomic,retain)CAShapeLayer *waveLayer;        //
@property(nonatomic,retain)CADisplayLink *waveDisplaylink;  //定时器(与屏幕刷新频率一致)

@end

@implementation JDWaterWaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _waveLayer =[[CAShapeLayer alloc]init];
        _waveA = 10;
        _waveW = (2 * M_PI) / self.bounds.size.width;
        _offsetX = 0;
        _currentK = self.bounds.size.height / 2;;
        _waveSpeed = 0.05;
        _waterWaveWidth =self.sizeWidth;
        
        [self addLayer];
    }
    return self;
}

- (void)addLayer {
   
    //设置闭环颜色
    _waveLayer.fillColor =JDRGBColor(73, 142, 178, 0.5).CGColor;
    //设置边缘线的颜色
    //_firstWaveLayer.strokeColor =[UIColor blueColor].CGColor;
    
    //们可以对绘制的Path进行分区。这两个属性的值在0~1之间，0代表Path的开始位置，1代表Path的结束位置。是一种线性递增关系。strokeStart默认值为0，strokeEnd默认值为1。这两个属性都支持动画。
    //_firstWaveLayer.strokeStart = 0.0;
    //_firstWaveLayer.strokeEnd = 0.8;
    
    [self.layer addSublayer:_waveLayer];
    
    //CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。
    _waveDisplaylink =[CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)getCurrentWave {
    
    _offsetX += _waveSpeed;
    [self setCurrentFirstWaveLayerPath];
    
}
- (void)setCurrentFirstWaveLayerPath {
    
    //创建一个路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _currentK;
    
    CGPathMoveToPoint(path, NULL, 0, y);
    for (CGFloat i =0; i<_waterWaveWidth; i++) {
        y =_waveA *sin(_waveW * i + _offsetX)+_currentK;
        CGPathAddLineToPoint(path, NULL, i, y);
    }
    CGPathAddLineToPoint(path, NULL, _waterWaveWidth, self.sizeHeight);
    CGPathAddLineToPoint(path, NULL, 0, self.sizeHeight);
    
    _waveLayer.path =path;
    
    //一定要加上这句,否则会有内存泄露
    CGPathRelease(path);
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (! newSuperview && _waveDisplaylink) {
        // 销毁定时器
        [_waveDisplaylink invalidate];
        _waveDisplaylink = nil;
    }

}

-(void)dealloc
{


}

@end
