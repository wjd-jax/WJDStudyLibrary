//
//  JDMarqueeView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDMarqueeView.h"

//每秒钟走几个字
const int num = 3;

@interface JDMarqueeView ()

@property (nonatomic,copy) NSString *msg; //需要展示的消息
@property (nonatomic,assign) CGFloat textW; //文字长度
@property (nonatomic,retain) UILabel *firstLabel; //跑马灯的两个 label
@property (nonatomic,retain) UILabel *secondLabel;

@end

@implementation JDMarqueeView

- (instancetype)initWithFrame:(CGRect)frame andMessage:(NSString *)message
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds =YES;
        _msg = [NSString stringWithFormat:@"    %@      ",message];
        self.backgroundColor =[[UIColor yellowColor] colorWithAlphaComponent:0.5];

        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    _firstLabel =[JDUtils createLabelWithFrame:CGRectZero Font:14 Text:_msg];
    _firstLabel.textAlignment =NSTextAlignmentLeft;
    [_firstLabel sizeToFit];
    //设置居中
    _firstLabel.centerY =self.sizeHeight/2;
    [self addSubview:_firstLabel];
    
    _textW = _firstLabel.sizeWidth;
    
    //如果文字长度大于控件宽度,则开始滚动
    if (_textW>self.sizeWidth) {
        
        _secondLabel =[JDUtils createLabelWithFrame:_firstLabel.frame Font:14 Text:_msg];
        _secondLabel.textAlignment =NSTextAlignmentLeft;
        _secondLabel.originX =CGRectGetMaxX(_firstLabel.frame);
        [_secondLabel sizeToFit];
        [self addSubview:_secondLabel];
        [self startAnimation];
    }
    
}
- (void)startAnimation
{
    //计算走完一次需要的时间
    NSInteger time = _msg.length / num;
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionRepeat animations:^{
        
        _firstLabel.originX =-_textW;
        _secondLabel.originX = 0;
        
    } completion:nil];
}
@end
