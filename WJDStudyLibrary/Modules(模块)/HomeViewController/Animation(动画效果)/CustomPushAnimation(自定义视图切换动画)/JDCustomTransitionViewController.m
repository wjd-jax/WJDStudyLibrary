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
                           @{@"title":@"系统TransAnimation动画",@"className":@"JDSystemTransAnimationViewController"},
                           @{@"title":@"自定义转场动画",@"className":@"JDCustomTransAnimationViewController"},
                           @{@"title":@"系统Present转场动画",@"className":@"JDSystemPresentAnimationViewController"},

                           ];
}

 

@end
