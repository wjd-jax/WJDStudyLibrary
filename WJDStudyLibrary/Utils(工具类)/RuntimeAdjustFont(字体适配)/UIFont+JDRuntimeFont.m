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

+ (void)load {
    
    //正常
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    method_exchangeImplementations(newMethod, method);
    
    //粗体
    Method adjustBlodFont = class_getClassMethod([self class], @selector(adjustBlodFont:));
    Method boldSystemFontOfSize = class_getClassMethod([self class], @selector(boldSystemFontOfSize:));
    method_exchangeImplementations(adjustBlodFont, boldSystemFontOfSize);
    
    //自定义字体
    Method adjustNameFont = class_getClassMethod([self class], @selector(adjustNameFont:size:));
    Method NameFontOfSize = class_getClassMethod([self class], @selector(fontWithName:size:));
    method_exchangeImplementations(adjustNameFont, NameFontOfSize);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width / UISize_With];
    return newFont;
}

+ (UIFont *)adjustBlodFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustBlodFont:fontSize * [UIScreen mainScreen].bounds.size.width / UISize_With];
    return newFont;
}

+ (UIFont *)adjustNameFont:(NSString *)fontName size:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustNameFont:fontName size:fontSize * [UIScreen mainScreen].bounds.size.width / UISize_With];
    return newFont;
}


@end
