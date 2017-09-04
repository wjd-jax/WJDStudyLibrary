//
//  JDCustomNavigationController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/29.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCustomNavigationController.h"
#import "define.h"

@interface JDCustomNavigationController ()

@end

@implementation JDCustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //重写了leftbarItem之后,需要添加如下方法才能重新启用右滑返回
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    // Do any additional setup after loading the view.
}

/* 某个页面导航栏透明,文字不透明
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 //设置导航栏背景图片为一个空的image，这样就透明了
 [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
 //去掉透明后导航栏下边的黑边
 [self.navigationBar setShadowImage:[[UIImage alloc] init]];
 }
 
 - (void)viewWillDisappear:(BOOL)animated{
 
 //如果不想让其他页面的导航栏变为透明 需要重置
 [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
 [self.navigationController.navigationBar setShadowImage:nil];
 }
 */

+ (void)initialize {
    //appearance方法返回一个导航栏的外观对象
    //修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    //设置导航栏背景颜色
    [navigationBar setBarTintColor:JDMainColor];
    //设置NavigationBarItem文字的颜色
    [navigationBar setTintColor:[UIColor whiteColor]];
    //设置标题栏颜色
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:18]};
    
    /*
     //设置导航栏文字的主题
     NSShadow *shadow = [[NSShadow alloc]init];
     [shadow setShadowOffset:CGSizeZero];
     [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSShadowAttributeName : shadow}];
     [navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_cell_bg_selected"] forBarMetrics:UIBarMetricsDefault];
     //修改所有UIBarButtonItem的外观
     UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
     
     // 修改item的背景图片
     //[barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     //[barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
     //修改item上面的文字样式
     NSDictionary *dict =@{NSForegroundColorAttributeName : [UIColor whiteColor],NSShadowAttributeName : shadow};
     [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
     [barButtonItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
     //修改返回按钮样式
     [barButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:NAVIGATION_BAR_BACK_ICON_NAME] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
     //设置状态栏样式
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
     */
}

//重写push后返回按钮的文字,文字可以为空字符串.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //修改返回文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    //全部修改返回按钮,但是会失去右滑返回的手势
    if (viewController.navigationItem.leftBarButtonItem ==nil && self.viewControllers.count >=1) {
        
        viewController.navigationItem.leftBarButtonItem = [self creatBackButton];
    }
    
    [super pushViewController:viewController animated:animated];
}


-(UIBarButtonItem *)creatBackButton
{
    return [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    
}

-(void)popSelf
{
    [self popViewControllerAnimated:YES];
}

@end
