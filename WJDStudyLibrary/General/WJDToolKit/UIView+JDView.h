//
//  UIView+JDView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JDView)

@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat sizeWidth;
@property (nonatomic, assign) CGFloat sizeHeight;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
