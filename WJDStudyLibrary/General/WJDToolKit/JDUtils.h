//
//  JDUtils.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDUtils : NSObject


//快速创建控件
+ (UIView *)createViewWithFrame:(CGRect)frame;
+ (UILabel *)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString *)text;
+ (UIButton *)createButtonWithFrame:(CGRect)frame ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action Title:(NSString *)title;
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;
+ (UIBarButtonItem *)createTextBarButtonWithTitle:(NSString *)title Target:(id)target Action:(SEL)action;
+ (UIBarButtonItem *)createImageBarButtonWithFrame:(CGRect)frame ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action;






@end
