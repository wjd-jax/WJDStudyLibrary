//
//  JDBaseViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDBaseViewController.h"

@interface JDBaseViewController ()

@end

@implementation JDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self createBar];
    // Do any additional setup after loading the view.
}


- (void)createBar {
    
    [self.view addSubview:self.navBgView];      //总背景
    [self.navBgView addSubview:self.statusBg];  //状态栏
    [self.navBgView addSubview:self.navBarBg];  //导航栏
    [self.navBarBg addSubview:self.titleLabel]; //标题
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:self.navBgView];
    
}

- (void)setHideNavBar:(BOOL)hideNavBar {
    
    self.navBgView.hidden = YES;
}
 
- (UIView *)navBgView {
    if (!_navBgView) {
        _navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, JD_NavTopHeight)];
        _navBgView.backgroundColor = JDRedColor;
    }
    return _navBgView;
}
#pragma mark - getter
-(UIView *)statusBg{
    if (!_statusBg) {
        _statusBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, JD_StatusBarHeight)];
    }
    return _statusBg;
}

-(UIView *)navBarBg{
    if (!_navBarBg) {
        _navBarBg = [[UIView alloc]initWithFrame:CGRectMake(0, JD_StatusBarHeight, KSCREEN_WIDTH, JD_NavBarHeight)];
    }
    return _navBarBg;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, KSCREEN_WIDTH - 160, JD_NavBarHeight)];
        _titleLabel.text = @"自定义标题";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
@end
