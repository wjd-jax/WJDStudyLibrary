//
//  JDAnimationListViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDAnimationListViewController.h"

@interface JDAnimationListViewController ()

@end

@implementation JDAnimationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[
                           @{@"title":@"水纹",@"className":@"JDWaterAnimationListViewController"},
                           @{@"title":@"转场动画",@"className":@"JDCustomTransitionViewController"},
                           @{@"title":@"基本动画",@"className":@"JDBaseAnimationViewController"},
                           @{@"title":@"粒子动画",@"className":@"JDEmitterViewController"},
                           @{@"title":@"绘制动画",@"className":@"JDDrawLineViewController"},
                           @{@"title":@"列表加载动画",@"className":@"JDShowTableViewController"},
                           ];
}



@end
