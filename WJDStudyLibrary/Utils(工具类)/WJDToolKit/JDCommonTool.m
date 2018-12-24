//
//  JDCommonTool.m
//  WJDStudyLibrary
//
//  Created by 王军东 on 2018/7/26.
//  Copyright © 2018年 wangjundong. All rights reserved.
//

#import "JDCommonTool.h"

@implementation JDCommonTool

+ (void)pushViewControllerWithStoryName:(NSString *)storyName ViewControllerName:(NSString *)viewControllerName fromNavigationController:(UINavigationController *)nav
{

    //将我们的storyBoard实例化，“Main”为StoryBoard的名称
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:storyName bundle:nil];
    //将第二个控制器实例化，"SecondViewController"为我们设置的控制器的ID
    UIViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:viewControllerName];
    [nav pushViewController:vc animated:YES];
    
}
@end
