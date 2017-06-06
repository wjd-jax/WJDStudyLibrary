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

@interface JDCustomTransAnimationViewController ()<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property (retain, nonatomic) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end

@implementation JDCustomTransAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[
                           @{@"title":@"自定义 Push转场动画",@"ClassName":@""},
                           @{@"title":@"自定义 Present转场动画",@"ClassName":@""},
                           ];
    
    //自定义导航栏控制器 push 动画的代理
    self.navigationController.delegate = self;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JDSystemTransTestViewController *vc =[[JDSystemTransTestViewController alloc]init];

    //这个代理也可以加到需要 present 的页面中
    vc.transitioningDelegate = self;

    if (indexPath.row == 1) {
        
        [self presentViewController:vc animated:YES completion:nil];
        [self addScreenLeftEdgePanGestureRecognizer:vc.view];

    }
    else
    [self.navigationController pushViewController:vc animated:YES];
    
}

//添加左侧拉动的手势
- (void)addScreenLeftEdgePanGestureRecognizer:(UIView *)view{
 
    //这个类的UIPanGestureRecognizer只承识别用户用手指从指定的边框的边缘滑动
    UIScreenEdgePanGestureRecognizer *screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    screenEdgePan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:screenEdgePan];
    
}


- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan{
    
    //滑动的进度
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].keyWindow].x/[UIApplication sharedApplication].keyWindow.bounds.size.width);
    
    if (edgePan.state == UIGestureRecognizerStateBegan) {
       
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        
        if (edgePan.edges == UIRectEdgeLeft) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }else if (edgePan.state == UIGestureRecognizerStateChanged){
        
        [self.percentDrivenTransition updateInteractiveTransition:progress];
        
    }else if (edgePan.state == UIGestureRecognizerStateEnded || edgePan.state == UIGestureRecognizerStateCancelled){
        
        if (progress > 0.5) {
            [_percentDrivenTransition finishInteractiveTransition];
        }else{
            [_percentDrivenTransition cancelInteractiveTransition];
        }
        _percentDrivenTransition = nil;
    }
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

#pragma mark -- 实现那个present和dismiss的代理方法

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[JDCustomPushAnimation alloc]init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[JDCustomPopAnimation alloc]init];
}

//获取交互式控制器，如果得到了nil则执行非交互式动画
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    
    return _percentDrivenTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    
    return _percentDrivenTransition;
}

@end
