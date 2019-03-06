//
//  UIView+JDView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JDView)

/*
 这句话可以给View设置圆角
 IBInspectable作用是给storyboard 上增加属性
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat boardWidth;
@property (nonatomic, strong) IBInspectable UIColor *boardColor;

@property (nonatomic, assign) CGFloat originX;
@property (nonatomic, assign) CGFloat originY;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat sizeWidth;
@property (nonatomic, assign) CGFloat sizeHeight;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic) CGFloat left;   ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;    ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;  ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom; ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;  ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height; ///< Shortcut for frame.size.height.

@end
