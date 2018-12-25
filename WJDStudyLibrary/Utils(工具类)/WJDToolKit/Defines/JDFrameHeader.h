//
//  JDFrameHeader.h
//  WJDStudyLibrary
//
//  Created by hzad on 2018/12/25.
//  Copyright © 2018 wangjundong. All rights reserved.
//

#ifndef JDFrameHeader_h
#define JDFrameHeader_h


#pragma mark-----------获取设备大小-----------

#define KSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)    //设备屏幕宽度
#define KSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)  //设备屏幕高度
#define JDScreenScale [UIScreen mainScreen].scale                  //设备分辨率系数
#define JDScreenBounds [UIScreen mainScreen].bounds                //屏幕bounds


#define JD_StatusBarHeight          \
[[UIApplication sharedApplication] statusBarFrame].size.height  //状态栏高度
#define JD_NavBarHeight 44.0                                        //NavBar高度
#define JD_TabBarHeight (JD_StatusBarHeight > 20 ? 83 : 49)         //底部tabbar高度
#define JD_NavTopHeight (JD_StatusBarHeight + JD_NavBarHeight)      //整个导航栏高度

#endif /* JDFrameHeader_h */
