//
//  JDUtils.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDUtils.h"
#import "define.h"

@implementation JDUtils

+ (UIView *)createViewWithFrame:(CGRect)frame
{
    UIView *view =[[UIView alloc]initWithFrame:frame];
    return view;
}
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame ImageName:(NSString *)image
{
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:frame];
    imageView.image =[UIImage imageNamed:image];
    return imageView;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString *)text
{
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    label.numberOfLines=0;                              //默认一行
    label.textAlignment=NSTextAlignmentLeft;            //默认对齐方式
    label.backgroundColor=[UIColor clearColor];
    label.font =[UIFont systemFontOfSize:font];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.textColor=[UIColor blackColor];               //默认字体颜色
    label.adjustsFontSizeToFitWidth=YES;                //自适应
    label.text=text;
    return label;
    
}

+ (UIButton *)createSystemButtonWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString *)title{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action Title:(NSString *)title
{
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:IMAGE_NAMED(imageName) forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font
{
    UITextField*textField=[[UITextField alloc]initWithFrame:frame];
    
    textField.placeholder=placeholder;                                      //灰色提示框
    textField.textAlignment=NSTextAlignmentLeft;                            //文字对齐方式
    textField.secureTextEntry=YESorNO;
    //textField.borderStyle=UITextBorderStyleLine;                          //边框
    textField.keyboardType=UIKeyboardTypeDefault;                           //键盘类型
    textField.autocapitalizationType=NO;                                    //关闭首字母大写
    textField.clearButtonMode=YES;                                          //清除按钮
    textField.clearButtonMode =UITextFieldViewModeWhileEditing;
    textField.leftView=imageView;                                           //左图片
    textField.leftViewMode=UITextFieldViewModeAlways;
    //textField.rightView=warnView;                                         //右图片
    //textField.rightView.hidden =YES;
    textField.rightViewMode=UITextFieldViewModeAlways;                      //编辑状态下一直存在
    if (rightImageView) {
        textField.rightView =rightImageView;
        textField.rightView.hidden =NO;
    }
    //textField.inputView                                                    //自定义键盘
    textField.font=  [UIFont systemFontOfSize:font];                         //字体
    //字体颜色
    textField.textColor=[UIColor blackColor];
    return textField ;
    
}

+ (UIBarButtonItem *)createTextBarButtonWithTitle:(NSString *)title Target:(id)target Action:(SEL)action
{
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    return barButton;
}

+ (UIBarButtonItem *)createImageBarButtonWithFrame:(CGRect)frame ImageName:(NSString *)imageName Target:(id)target Action:(SEL)action
{
    UIButton *button =[self createButtonWithFrame:frame ImageName:imageName Target:target Action:action Title:nil];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}

@end
