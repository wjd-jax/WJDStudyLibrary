//
//  JDCommonTool.h
//  WJDStudyLibrary
//
//  Created by 王军东 on 2018/7/26.
//  Copyright © 2018年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDCommonTool : NSObject

/**
 跳转到storyboard的某一个页面

 @param storyName storyboard名字
 @param ViewControllerName vc名字
 @param nav 导航栏控制器
 */
+ (void)pushViewControllerWithStoryName:(NSString *)storyName ViewControllerName:(NSString *)viewControllerName fromNavigationController:(UINavigationController *)nav;
@end
