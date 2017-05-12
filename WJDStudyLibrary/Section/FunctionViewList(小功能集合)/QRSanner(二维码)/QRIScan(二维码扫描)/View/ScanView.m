//
//  ScanView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/8.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "ScanView.h"

@interface ScanView ()

@property (nonatomic,strong)CALayer *lineLayer;

@end

@implementation ScanView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setLayoutView];
    }
    return self;
}

- (void)setLayoutView{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.lineLayer = [CALayer layer];
    self.lineLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"line"].CGImage);
    [self.layer addSublayer:self.lineLayer];
    [self run];
    
    self.lineLayer.frame = CGRectMake((self.frame.size.width - 300) / 2, (self.frame.size.height - 300) / 2+20, 300, 2);
}

- (void)drawRect:(CGRect)rect{
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat pickingFieldWidth = 300;
    CGFloat pickingFieldHeight = 300;
    
    //创建上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //将当前图形状态推入堆栈。之后,您对图形状态所做的修改会影响随后的描画操作,但不影响存储在堆栈中的拷贝
    CGContextSaveGState(contextRef);
    //设置填充颜色
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.35);
    //线的宽度(锯齿显示)
    CGContextSetLineWidth(contextRef, 3);
    
    _scanRect = CGRectMake((width - pickingFieldWidth)/2, (height - pickingFieldHeight)/2, pickingFieldWidth, pickingFieldHeight);

    /**
     bezierPathWithRect : 根据一个矩形画线
     */
    UIBezierPath *pickingFieldPath = [UIBezierPath bezierPathWithRect:_scanRect];
    UIBezierPath *bezierPathRect = [UIBezierPath bezierPathWithRect:rect];
    //
    [bezierPathRect appendPath:pickingFieldPath];
    
    //填充使用奇偶法则(NO为非0法则)
    bezierPathRect.usesEvenOddFillRule = YES;
    //填充
    [bezierPathRect fill];
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetRGBStrokeColor(contextRef, 27/255.0, 181/255.0, 254/255.0, 1);
    [pickingFieldPath stroke];
    
    CGContextRestoreGState(contextRef);
    //集中在水平和垂直方向的矩形
    self.layer.contentsGravity = kCAGravityCenter;
}


- (void)run{
    
   
    [self.layer addSublayer:self.lineLayer];
    
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    basic.fromValue = @(0);
    basic.toValue = @(280);
    basic.duration = 1.5;
    basic.repeatCount= NSIntegerMax;
    basic.removedOnCompletion = NO;
    [self.lineLayer addAnimation:basic forKey:@"translationY"];
    
}


- (void)pause{
    
    [self.lineLayer removeAnimationForKey:@"translationY"];
    [self.lineLayer removeFromSuperlayer];

}

@end
