//
//  JDCustomTransAnimationViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCustomTransAnimationViewController.h"
#import "JDSystemTransTestViewController.h"
#import "JDCustomPushAnimation.h"
#import "JDCustomPopAnimation.h"
@interface JDCustomTransAnimationViewController ()<UINavigationControllerDelegate>

@end

@implementation JDCustomTransAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[
                           @{@"title":@"不带交互的转场动画",@"ClassName":@""},
                           @{@"title":@"带交互转场动画",@"ClassName":@""},
                           
                           ];
    self.navigationController.delegate = self;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JDSystemTransTestViewController *vc =[[JDSystemTransTestViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -- 实现导航控制器的代理方法
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    //判断当前是push还是pop
    if (operation == UINavigationControllerOperationPush)
    
        return [[JDCustomPushAnimation alloc]init];
    else
    //如果我们写了pop的动画工具类的话，这里就填pop的
        return [[JDCustomPopAnimation alloc]init];
}
@end
