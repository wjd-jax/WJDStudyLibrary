//
//  JDCardScanView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCardScanView.h"

// iPhone5/5c/5s/SE 4英寸 屏幕宽高：320*568点 屏幕模式：2x 分辨率：1136*640像素
#define iPhone5or5cor5sorSE ([UIScreen mainScreen].bounds.size.height == 568.0)

// iPhone6/6s/7 4.7英寸 屏幕宽高：375*667点 屏幕模式：2x 分辨率：1334*750像素
#define iPhone6or6sor7 ([UIScreen mainScreen].bounds.size.height == 667.0)

// iPhone6 Plus/6s Plus/7 Plus 5.5英寸 屏幕宽高：414*736点 屏幕模式：3x 分辨率：1920*1080像素
#define iPhone6Plusor6sPlusor7Plus ([UIScreen mainScreen].bounds.size.height == 736.0)


@interface JDCardScanView () {
    CAShapeLayer *_IDCardScanningWindowLayer;
    NSTimer *_timer;
}

@end

@implementation JDCardScanView

- (instancetype)initWithFrame:(CGRect)frame {
    
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 添加扫描窗口
        [self addScaningWindow];
        // 添加定时器
        [self addTimer];
    }
    
    return self;
}

#pragma mark - 添加扫描窗口
-(void)addScaningWindow {
    // 中间包裹线
    _IDCardScanningWindowLayer = [CAShapeLayer layer];
    _IDCardScanningWindowLayer.position = self.layer.position;
    CGFloat width = iPhone5or5cor5sorSE? 240: (iPhone6or6sor7? 270: 300);
    _IDCardScanningWindowLayer.bounds = (CGRect){CGPointZero, {width, width * 1.574}};
    _IDCardScanningWindowLayer.cornerRadius = 15;
    _IDCardScanningWindowLayer.borderColor = [UIColor whiteColor].CGColor;
    _IDCardScanningWindowLayer.borderWidth = 1.5;
    [self.layer addSublayer:_IDCardScanningWindowLayer];
    
    // 最里层镂空
    UIBezierPath *transparentRoundedRectPath = [UIBezierPath bezierPathWithRoundedRect:_IDCardScanningWindowLayer.frame cornerRadius:_IDCardScanningWindowLayer.cornerRadius];
    
    // 最外层背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    [path appendPath:transparentRoundedRectPath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.6;
    
    [self.layer addSublayer:fillLayer];
    
//    CGFloat facePathWidth = iPhone5or5cor5sorSE? 125: (iPhone6or6sor7? 150: 180);
//    CGFloat facePathHeight = facePathWidth * 0.812;
//    CGRect rect = _IDCardScanningWindowLayer.frame;
//    self.facePathRect = (CGRect){CGRectGetMaxX(rect) - facePathWidth - 35,CGRectGetMaxY(rect) - facePathHeight - 25,facePathWidth,facePathHeight};
    
    // 提示标签
    CGPoint center = self.center;
    center.x = CGRectGetMaxX(_IDCardScanningWindowLayer.frame) + 20;
    [self addTipLabelWithText:@"将身份证置于此区域内" center:center];
    
    /*
     CGPoint center1 = (CGPoint){CGRectGetMidX(_facePathRect), CGRectGetMidY(_facePathRect)};
     [self addTipLabelWithText:@"人像" center:center1];
     */
    
    // 人像
//    UIImageView *headIV = [[UIImageView alloc] initWithFrame:_facePathRect];
//    headIV.image = [UIImage imageNamed:@"idcard_first_head"];
//    headIV.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
//    headIV.contentMode = UIViewContentModeScaleAspectFill;
//    [self addSubview:headIV];
}

#pragma mark - 添加提示标签
-(void )addTipLabelWithText:(NSString *)text center:(CGPoint)center {
    UILabel *tipLabel = [[UILabel alloc] init];
    
    tipLabel.text = text;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    
    tipLabel.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    [tipLabel sizeToFit];
    
    tipLabel.center = center;
    
    [self addSubview:tipLabel];
}

#pragma mark - 添加定时器
-(void)addTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    [_timer fire];
}

-(void)timerFire:(id)notice {
    [self setNeedsDisplay];
}

-(void)dealloc {

}

- (void)drawRect:(CGRect)rect {
    
    rect = _IDCardScanningWindowLayer.frame;
    
//    // 人像提示框
//    UIBezierPath *facePath = [UIBezierPath bezierPathWithRect:_facePathRect];
//    facePath.lineWidth = 1.5;
//    [[UIColor whiteColor] set];
//    [facePath stroke];
    
    // 水平扫描线
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    static CGFloat moveX = 0;
    static CGFloat distanceX = 0;
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2);
    CGContextSetRGBStrokeColor(context,0.3,0.8,0.3,0.8);
    CGPoint p1, p2;// p1, p2 连成水平扫描线;
    
    moveX += distanceX;
    if (moveX >= CGRectGetWidth(rect) - 2) {
        distanceX = -2;
    } else if (moveX <= 2){
        distanceX = 2;
    }
    
    p1 = CGPointMake(CGRectGetMaxX(rect) - moveX, rect.origin.y);
    p2 = CGPointMake(CGRectGetMaxX(rect) - moveX, rect.origin.y + rect.size.height);
    
    CGContextMoveToPoint(context,p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    
    CGContextStrokePath(context);
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (! newSuperview && _timer) {
        // 销毁定时器
        [_timer invalidate];
        _timer = nil;
    }
}


@end
