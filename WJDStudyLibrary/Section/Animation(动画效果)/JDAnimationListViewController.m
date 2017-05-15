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
                           @{@"title":@"水纹",@"ClassName":@"JDWaterAnimationListViewController"},
                           @{@"title":@"转场动画",@"ClassName":@"JDCustomTransitionViewController"},
                           @{@"title":@"基本动画",@"ClassName":@"JDBaseAnimationViewController"},
                           @{@"title":@"粒子动画",@"ClassName":@"JDEmitterViewController"},
                           @{@"title":@"绘制动画",@"ClassName":@"JDDrawLineViewController"},
                           @{@"title":@"轨迹动画CAKeyframeAnimation",@"ClassName":@"JDCAKeyframeAnimationViewController"},

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
