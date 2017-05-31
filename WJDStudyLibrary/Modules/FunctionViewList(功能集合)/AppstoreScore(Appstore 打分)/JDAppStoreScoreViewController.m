//
//  JDAppStoreScoreViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/4.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDAppStoreScoreViewController.h"
#import <StoreKit/StoreKit.h>
#import "Availability.h"
#define KAPPID @"1192947691"
@interface JDAppStoreScoreViewController ()<SKStoreProductViewControllerDelegate>
{
    SKStoreProductViewController *storeProductViewController;
}
@end

@implementation JDAppStoreScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    storeProductViewController =[[SKStoreProductViewController alloc]init];
    storeProductViewController.delegate =self;
    
    UIButton *button1 =[JDUtils  createSystemButtonWithFrame:CGRectMake(10, 50+64, 400, 30) Target:self Action:@selector(buttonClick1) Title:@"跳转到Appstore打开评分"];
    button1.centerX =SCREEN_WIDHT/2;
    [self.view addSubview:button1];
    
    UIButton *button2 =[JDUtils  createSystemButtonWithFrame:CGRectMake(10, 50+64+60, 400, 30) Target:self Action:@selector(buttonClick2) Title:@"APP内部打开页面跳转到评分"];
    button2.centerX =SCREEN_WIDHT/2;
    
    [self.view addSubview:button2];
    
    UIButton *button3 =[JDUtils  createSystemButtonWithFrame:CGRectMake(10, 100+64+60, 400, 30) Target:self Action:@selector(buttonClick3) Title:@"APP内打开评分弹框(IOS10.3之后的方法)"];
    button3.centerX =SCREEN_WIDHT/2;
    
    [self.view addSubview:button3];
    
}

- (void)buttonClick1 {
    
    
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", KAPPID];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
    
    
    
}

- (void)buttonClick2 {
    
    /*
     >>>>>苹果IOS6.0提供了一个框架StoreKit.framework,
     1.导入StoreKit.framework,
     2.在需要跳转的控制器里面添加头文件 #import <StoreKit/StoreKit.h>,
     3.实现代理方法：< SKStorePRoductViewControllerDelegate >
     
     */
    
    [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:KAPPID} completionBlock:^(BOOL result, NSError * _Nullable error) {
        
        if (error)
            DLog(@"error %@ with userInfo %@",error,[error userInfo]);
        else
            [self presentViewController:storeProductViewController animated:YES completion:nil];
    }];
}

- (void)buttonClick3 {
    
    
    if (iOS10_3)
        //至此就实现在App内直接评论了。然而需要注意的是：打开次数一年不能多于3次。（当然开发期间可以无限制弹出，方便测试）
        [SKStoreReviewController requestReview];
    else
        [JDMessageView showMessage:@"版本不支持此方法"];
    
}
//Appstore 取消按钮监听
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [storeProductViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
