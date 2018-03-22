//
//  JDCardInfoView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2018/2/22.
//  Copyright © 2018年 wangjundong. All rights reserved.
//

#import "JDCardInfoView.h"

@implementation JDCardInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UIView *cardView  = [[UIView alloc]initWithFrame: CGRectMake(10, Navigation_HEIGHT + 10, SCREEN_WIDHT-20, (SCREEN_WIDHT-20)/2)];
    cardView.backgroundColor  = JDCOLOR_FROM_RGB_OxFF_ALPHA(0xfde2b1, 1);
    cardView.layer.cornerRadius = 5;
    //    JDViewSetRadius(cardView, 10)
    
    [self addSubview:cardView];
    
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOpacity = 0.8f;
    cardView.layer.shadowRadius = 4.f;
    cardView.layer.shadowOffset = CGSizeMake(4, 4);
    
}



@end
