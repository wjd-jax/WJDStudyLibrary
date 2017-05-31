//
//  JDCustomTransitionViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCustomTransitionViewController.h"

@interface JDCustomTransitionViewController ()

@end

@implementation JDCustomTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[
                           @{@"title":@"系统TransAnimation动画",@"ClassName":@"JDSystemTransAnimationViewController"},
                           @{@"title":@"自定义转场动画",@"ClassName":@"JDCustomTransAnimationViewController"},
                           @{@"title":@"系统Present转场动画",@"ClassName":@"JDSystemPresentAnimationViewController"},

                           ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
