//
//  JDUtils.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//  UI工厂类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JDUIFactory : NSObject

//快速创建控件

//View工厂

+ (UIView *)createViewWithFrame:(CGRect)frame;

+ (UIView *)createViewWithFrame:(CGRect)frame
                          Color:(UIColor *)color;

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame
                                ImageName:(NSString *)image;

//Label工厂
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             FontSize:(int)fontSize
                             Text:(NSString *)text;

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             FontSize:(int)fontSize
                             Text:(NSString *)text
                        textColor:(UIColor *)color;

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             FontSize:(int)fontSize
                             Text:(NSString *)text
                        textColor:(UIColor *)color
                  NSTextAlignment:(NSTextAlignment)alignment;

//Button工厂
+ (UIButton *)createButtonWithFrame:(CGRect)frame
                          ImageName:(NSString *)imageName
                             Target:(id)target
                             Action:(SEL)action
                              Title:(NSString *)title;

+ (UIButton *)createSystemButtonWithFrame:(CGRect)frame
                                   Target:(id)target
                                   Action:(SEL)action
                                    Title:(NSString *)title;

//TextField工厂

/**
 快速创建TextField

 @param frame frame
 @param placeholder 默认文字
 @param YESorNO 是否是密码
 @param imageView 左侧图片
 @param rightImageView 右侧图片
 @param font 字体
 @return UITextField
 */
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                              placeholder:(NSString *)placeholder
                                 passWord:(BOOL)YESorNO
                            leftImageView:(UIView *)imageView
                           rightImageView:(UIImageView *)rightImageView
                                     FontSize:(float)fontSize;

//UIBarButtonItem工厂
+ (UIBarButtonItem *)createTextBarButtonWithTitle:(NSString *)title
                                           Target:(id)target
                                           Action:(SEL)action;

+ (UIBarButtonItem *)createImageBarButtonWithFrame:(CGRect)frame
                                         ImageName:(NSString *)imageName
                                            Target:(id)target
                                            Action:(SEL)action;

@end
