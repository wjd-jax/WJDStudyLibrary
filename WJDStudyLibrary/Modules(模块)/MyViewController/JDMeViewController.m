//
//  JDMeViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/20.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDMeViewController.h"
#import "JDCardInfoView.h"

@interface JDMeViewController ()
//<
//UITableViewDelegate,
//UITableViewDataSource
//>


@end

@implementation JDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
   
}
- (void)createUI{
    //个人名片
    JDCardInfoView *cardView = [[JDCardInfoView alloc]init];
    [self.view addSubview:cardView];
    
}


@end
