//
//  JDGuidePageView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/29.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDGuidePageView : UIView

/**
 选中的page指示器颜色,默认灰色
 */
@property(nonatomic,retain)UIColor *currentColor;

/**
 非当前页page圆点的颜色,默认白色
 */
@property(nonatomic,retain)UIColor *nomalColor;

/**
 是否显示小圆点
 */
@property(nonatomic,assign)BOOL isShowPageView;

/**
 是否滑动到最后一页移除引导页,默认是
 */
@property(nonatomic,assign)BOOL isScrollOut;

- (instancetype)initGuideViewWithImages:(NSArray *)imageNames;

- (instancetype)initGuideViewWithImages:(NSArray *)imageNames button:(UIButton *)button;


@end
