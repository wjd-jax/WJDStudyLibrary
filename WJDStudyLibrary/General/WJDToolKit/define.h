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
#define NavigationBar_HEIGHT 64
#define SCREEN_WIDHT ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//-------------------打印日志-------------------------
//DEBUG 模式下打印日志,当前行
#ifdef DEBUG

#define DLog(format,...) printf("%s [Line %d]  \n%s\n",__PRETTY_FUNCTION__, __LINE__,[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else

# define DLog(...)

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
#define JDRandomColor  [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:0.3];

//设置 RGBA 颜色
#define JDRGBColor(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:A]
#define JDClearColor [UIColor clearColor];

//弱引用/强引用
#define JDWeakSelf(type) __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;

//设置 View 边框粗细和颜色
#define JDViewBorderRadius(View,Width,color)\
\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:color]
//设置圆角
#define JDViewSetRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\


//获取图片
#define JDGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//获取当前语言
#define JDCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//GCD 的宏定义
//GCD - 一次性执行

#define JDDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken;dispatch_once(&onceToken, onceBlock);

//GCD - 在Main线程上运行
#define JDDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//GCD - 开启异步线程
#define JDDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

#endif /* Defintion_h */
