//
//  JDCustomPresentAnimation.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCustomPushAnimation.h"

@implementation JDCustomPushAnimation

#pragma mark - 利用转场上下文写动画
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    toVC.view.frame = containerView.bounds;
    toVC.view.alpha = 0;
    toVC.view.layer.transform = CATransform3DMakeScale(0, 0, 0);
    
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        toVC.view.alpha = 1;
        toVC.view.layer.transform = CATransform3DIdentity;
        
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:YES];
    }];

}
#pragma mark - 返回转场动画执行时间
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
@end
