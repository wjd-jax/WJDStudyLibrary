//
//  JDBottomAlignmentLabel.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDBottomAlignmentLabel.h"

@implementation JDBottomAlignmentLabel


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    }
    return self;
}

-(void)addText:(NSString *)text Font:(UIFont *)font TextColor:(UIColor *)textColor IsChinese:(BOOL)isChinese
{
    //label
    UILabel *label =[[UILabel alloc]init];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    //size
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    
    //ascender属性：基准线以上的最高y坐标。
    //capHeight属性：The receiver’s cap height information 接收者的大写高度信息？？
    
    CGFloat labelH = isChinese ? font.ascender : font.capHeight;
    
    //frame
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.bounds.size.width + size.width,
                            MAX(labelH, self.bounds.size.height));
    
    label.frame = CGRectMake(self.bounds.size.width - size.width,
                             self.frame.size.height - labelH,
                             size.width,
                             labelH);
    float maxH = 0;
    for (UILabel *slabel in self.subviews) {
        
        
        maxH = slabel.frame.size.height >maxH? slabel.frame.size.height : maxH;
        
    }
    for (UILabel *slabel in self.subviews) {
        
        if(slabel.frame.size.height < maxH)
        {
            CGRect rect = slabel.frame;
            rect.origin.y = (maxH - slabel.bounds.size.height);
            slabel.frame = rect;
        }
    }
    
    
}

-(void)removeAllText{
    
    for (UILabel *label in self.subviews) {
        [label removeFromSuperview];
    }
    self.frame = CGRectMake(0, 0, 0, 0);
}

@end
