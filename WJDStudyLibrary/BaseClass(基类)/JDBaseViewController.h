//
//  JDBaseViewController.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDBaseViewController : UIViewController

@property (nonatomic, strong) UIView *navBgView;   //整体导航背景
@property (nonatomic, strong) UIView *statusBg;    //状态栏
@property (nonatomic, strong) UIView *navBarBg;    //导航栏
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UIButton *leftBtn;   //左侧按钮
@property (nonatomic, strong) UIButton *rightBtn;  //右侧按钮

@property (nonatomic,assign) BOOL hideNavBar;//隐藏导航栏

@end
