//
//  JDGuiewManager.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDGuiewManager : NSObject


/**
 展示引导页面

 @param tapViews 需要显示的区域控件数组
 @param tips 对应 view 的提示信息(提示信息如果没有,请输入@"")
 */
+ (void)showGuideViewWithTapViews:(NSArray<UIView *>*)tapViews tip:(NSArray<NSString *>*)tips;

@end
