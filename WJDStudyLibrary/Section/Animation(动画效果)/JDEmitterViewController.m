//
//  JDEmitterViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDEmitterViewController.h"

@interface JDEmitterViewController ()

@end

@implementation JDEmitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[
                           @{@"title":@"蜡烛火焰",@"ClassName":@"JDFireEmitterViewController"},
                           @{@"title":@"下雨",@"ClassName":@"JDCus2tomTransitionViewController"},
                           @{@"title":@"下雪动画",@"ClassName":@"JDSnowViewController"},
                           @{@"title":@"烟花动画",@"ClassName":@"JDFireworksViewController.h"},

                           ];}

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
