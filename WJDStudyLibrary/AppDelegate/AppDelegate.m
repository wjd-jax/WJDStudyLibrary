//
//  AppDelegate.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "JDAuthorityManager.h"
#import "AppDelegate+JDPush.h"
#import "JDGuidePageViewController.h"
#import "JDGuidePageView.h"
#import "JDTabBarController.h"
#import <UIImageView+WebCache.h>
#import "JDImageCacheManager.h"
#import "JDRSAUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor =[UIColor whiteColor];
    
#if DEBUG
    
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
    [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    
#endif
    
  UIImage *image =   [[JDImageCacheManager shareInstance] getImageCacheWithURLString:@"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png"];
    DLog(@"%@",image);
    //请求权限
    [JDAuthorityManager requestAllAuthority];
    //注册推送
    [self regisNotification];
    
    JDTabBarController *rootVC =[[JDTabBarController alloc]init];

    _window.rootViewController =rootVC;
    
    [_window makeKeyAndVisible];
    
    //引导页.一定要在[_window makeKeyAndVisible]之后调用
    if ([self isFirstLauch]) {
        
        JDGuidePageView *guideView =[[JDGuidePageView alloc]initGuideViewWithImages:@[@"guide_01", @"guide_02", @"guide_03",@"guide_04"] ];
        guideView.isShowPageView = YES;
        guideView.isScrollOut = NO;
        guideView.currentColor =[UIColor redColor];
        [_window addSubview:guideView];
    }
    //给 launch 添加动画
    [self addLaunchAnimation];
    
    return YES;
}


#pragma mark - 判断是不是首次登录或者版本更新
- (BOOL)isFirstLauch{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"7ppBC736jT";
    
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
    
}

#pragma mark - 添加启动动画(此方法要在rootviewcontroller之后添加)
- (void)addLaunchAnimation
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    
    //UIView *launchView = viewController.view;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    
    //viewController.view.frame = [UIApplication sharedApplication].keyWindow.frame;
    [mainWindow addSubview:viewController.view];
    [self.window bringSubviewToFront:viewController.view];
    
    //添加广告图
    /*
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, KSCREEN_WIDTH, 300)];
    NSString *str = @"http://upload-images.jianshu.io/upload_images/746057-6e83c64b3e1ec4d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
    [imageV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"default1.jpg"]];
    [viewController.view addSubview:imageV];
    */
    [UIView animateWithDuration:0.6f delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        viewController.view.alpha = 0.0f;
        viewController.view.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
        
    } completion:^(BOOL finished) {
        [viewController.view removeFromSuperview];
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
