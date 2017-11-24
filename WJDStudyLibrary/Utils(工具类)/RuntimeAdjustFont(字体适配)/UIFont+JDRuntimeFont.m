//
//  UIFont+JDRuntimeFont.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "UIFont+JDRuntimeFont.h"
#import <objc/runtime.h>

#define UISize_With 375  //设计参考的屏幕宽度

@implementation UIFont (JDRuntimeFont)

+ (void)load{
    //获取替换后的类方法
    Method newMethod =class_getClassMethod([self class], @selector(adjustFont:));
    //获取需要替换的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    //交换方法
    method_exchangeImplementations(newMethod, method);

}

+ (UIFont *)adjustFont:(CGFloat)fontSize{
    UIFont *newFont=nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/UISize_With];
    return newFont;
}

@end
