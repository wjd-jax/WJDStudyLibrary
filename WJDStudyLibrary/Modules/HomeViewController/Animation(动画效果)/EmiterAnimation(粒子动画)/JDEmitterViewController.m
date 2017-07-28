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
                           @{@"title":@"下雨",@"ClassName":@"JDRainViewController"},
                           @{@"title":@"下雪动画",@"ClassName":@"JDSnowViewController"},
                           @{@"title":@"烟花动画",@"ClassName":@"JDFireworksViewController"},
                           @{@"title":@"火焰动画",@"ClassName":@"JDFireViewController"},


                           ];}

 

@end
