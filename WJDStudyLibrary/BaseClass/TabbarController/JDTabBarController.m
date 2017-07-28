//
//  JDTabBarController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/20.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDTabBarController.h"


#import "MainViewController.h"
#import "JDFindViewController.h"
#import "JDMeViewController.h"
#import "JDMessageViewController.h"

#import "JDCustomNavigationController.h"

@interface JDTabBarController ()

@property(nonatomic,strong) NSMutableArray *items;

@property(nonatomic,retain) MainViewController *home;
@property(nonatomic,retain) JDMessageViewController *message;
@property(nonatomic,retain) JDFindViewController *discover;
@property(nonatomic,retain) JDMeViewController *me;

@end

@implementation JDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self setUpAllChildViewController];
    [self setUpTabBar];
}

- (NSMutableArray *)item
{
    if (!_items) {
        _items =[NSMutableArray array];
    }
    return _items;
}


// 在iOS7 之后，默认会把uitabBar上的系统图片渲染成蓝色,可以在Assets.xcassets中把图片的image set的Render as设置为Original image
#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController
{
    
    _home =[[MainViewController alloc]init];
    _message =[[JDMessageViewController alloc]init];
    _discover =[[JDFindViewController alloc]init];
    _me = [[JDMeViewController alloc]init];
    
    [self setUpOneChildViewController:_home image:[UIImage imageNamed:@"tabbar_home"]
                        selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]
                                title:@"首页"];
    [self setUpOneChildViewController:_message image:[UIImage imageNamed:@"tabbar_message_center"]
                        selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"]
                                title:@"消息"];
    [self setUpOneChildViewController:_discover image:[UIImage imageNamed:@"tabbar_discover"]
                        selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]
                                title:@"发现"];
    [self setUpOneChildViewController:_me image:[UIImage imageNamed:@"tabbar_profile"]
                        selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]
                                title:@"我的"];
    
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    [vc.tabBarItem setTitleTextAttributes:@{
                                            NSFontAttributeName :            [UIFont systemFontOfSize:10],
                                            NSForegroundColorAttributeName : [UIColor orangeColor]
                                            }
                                 forState:UIControlStateSelected];
    
    //[vc.tabBarItem setTitleTextAttributes:@{} forState:UIControlStateSelected];
    
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    
    JDCustomNavigationController *nav = [[JDCustomNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
    
}

#pragma mark - 设置tabBar
- (void)setUpTabBar
{
    
}

@end
