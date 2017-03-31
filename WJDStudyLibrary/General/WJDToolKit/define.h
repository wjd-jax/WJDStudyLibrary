//
//  Defintion.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#ifndef Defintion_h
#define Defintion_h
//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44
#define SCREEN_WIDHT ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//-------------------打印日志-------------------------
//DEBUG 模式下打印日志,当前行
#ifdef DEBUG

# define DLog(fmt,...) NSLog((@"%s[Line %d]",fmt,, __PRETTY_FUNCTION__,__LINE__,##_VAARGS__);

#else

# define Dlog(...)

#endif

//----------------------系统----------------------------
//判断是真机还是模拟器
#if TARGET_OS_IPHONE

#endif

#if TARGET_IPHONE_SIMULATOR

#endif

//----------------------沙盒目录文件----------------------------
//获取Temp 目录
#define kPathTem NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSdocumentDirectory,NSUserDomainMask,YES) firstObject];
//获取沙盒 Cache
#define kPathCache    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

//----------------------快捷操作----------------------------
//获取通知中心
#define JDNotificationCenter [NSNotificationCenter defaultCenter]
//设置随机颜色
#define JDRandomColor  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
//设置 RGBA 颜色
#define JDRGBColor(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A]
#define JDClearColor [UIColor clearColor];



#endif /* Defintion_h */
