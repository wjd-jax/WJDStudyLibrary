//
//  JDColorsHeaders.h
//  WJDStudyLibrary
//
//  Created by hzad on 2018/12/25.
//  Copyright © 2018 wangjundong. All rights reserved.
//

#ifndef JDColorsHeaders_h
#define JDColorsHeaders_h


#pragma mark-----------颜色操作-----------

#define JDMainColor     JDRGBAColor(55, 207, 240, 1) //主色调

//设置随机颜色
#define JDRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:0.1];

//格式0xdae8a6
#define JDCOLOR_FROM_RGB_OxFF_ALPHA(rgbValue, al)                        \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
blue:((float)(rgbValue & 0xFF)) / 255.0             \
alpha:al]

//设置 RGBA 颜色
#define JDRGBAColor(R, G, B, A)\
[UIColor colorWithRed:(R) / 255.0 green:(G) / 255.0 blue:(B) / 255.0 alpha:A]

#define JDRGBColor(R, G, B)\
[UIColor colorWithRed:(R) / 255.0 green:(G) / 255.0 blue:(B) / 255.0 alpha:1]


//常用颜色简写
#define JDBlackColor     [UIColor blackColor]   //黑
#define JDBlueColor      [UIColor blueColor]    //蓝
#define JDRedColor       [UIColor redColor]     //红
#define JDWhiteColor     [UIColor whiteColor]   //白
#define JDGrayColor      [UIColor grayColor]    //灰
#define JDDarkGrayColor  [UIColor darkGrayColor]
#define JDLightGrayColor [UIColor lightGrayColor]
#define JDGreenColor     [UIColor greenColor]
#define JDCyanColor      [UIColor cyanColor]
#define JDYellowColor    [UIColor yellowColor]
#define JDMagentaColor   [UIColor magentaColor]
#define JDOrangeColor    [UIColor orangeColor]
#define JDPurpleColor    [UIColor purpleColor]
#define JDBrownColor     [UIColor brownColor]
#define JDClearColor     [UIColor clearColor]

#endif /* JDColorsHeaders_h */
