//
//  JDCustomPopAnimation.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/1.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCustomPopAnimation.h"

@implementation JDCustomPopAnimation


#pragma mark - 利用转场上下文写动画
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    //获取view
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //给toView的形变属性设值(缩小一点点)
    toView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    UIView *containerView = [transitionContext containerView];
    
    //将toView加到FromView之下
    [containerView insertSubview:toView belowSubview:fromView];
    
    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //把来自的view放到屏幕右面去
//        fromView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 2, fromView.center.y);
        //from 页面缩小到消失
        fromView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        //将这个恢复其形变属性
        toView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        

        [fromView removeFromSuperview];
        //将这个恢复其形变属性
        toView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:YES];
        
    }];

    
}
#pragma mark - 返回转场动画执行时间
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
@end
