//
//  JDBaseAnimationViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDBaseAnimationViewController.h"

@interface JDBaseAnimationViewController ()

@end

@implementation JDBaseAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**------------------------旋转动画-------------------------------------*/
    
    //以 中心x 轴 翻转
    UIImageView *rorationImageViewX =[JDUtils createImageViewWithFrame:CGRectMake(20, 100, 70, 70) ImageName:@"apple"];
    [self.view addSubview:rorationImageViewX];
    //设置layer坐标系的中心点默认是(0.5,0.5)
    //rorationImageViewX.layer.anchorPoint =CGPointMake(0, 0.5);
    CABasicAnimation *rorationAnimX =[CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rorationAnimX.beginTime =0;
    rorationAnimX.toValue = @(2*M_PI);
    rorationAnimX.duration =1.5;
    rorationAnimX.removedOnCompletion = NO;
    rorationAnimX.repeatCount = INFINITY;
    [rorationImageViewX.layer addAnimation:rorationAnimX forKey:@"rotationAnimX"];
    
    //以 中心y 轴 翻转
    UIImageView *rorationImageViewY =[JDUtils createImageViewWithFrame:CGRectMake(150, 100, 70, 70) ImageName:@"apple"];
    [self.view addSubview:rorationImageViewY];
    
    CABasicAnimation *rorationAnimY =[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rorationAnimY.beginTime =0;
    rorationAnimY.toValue = @(2*M_PI);
    rorationAnimY.duration =1.5;
    rorationAnimY.removedOnCompletion = NO;
    rorationAnimY.repeatCount = INFINITY;
    [rorationImageViewY.layer addAnimation:rorationAnimY forKey:@"rotationAnimX"];
    
    //以 中心 z 轴 翻转
    UIImageView *rorationViewZ = [JDUtils createImageViewWithFrame:CGRectMake(280, 100, 70, 70) ImageName:@"apple"];
    [self.view addSubview:rorationViewZ];
    
    CABasicAnimation *rotationAnimZ = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimZ.beginTime = 0.0;
    rotationAnimZ.toValue = @(2*M_PI);
    rotationAnimZ.duration = 1.5;
    rotationAnimZ.repeatCount = INFINITY;
    [rorationViewZ.layer addAnimation:rotationAnimZ forKey:@"rotationAnimZ"];
    
    /**------------------------移动动画-------------------------------------*/
    UIImageView *moveView = [JDUtils createImageViewWithFrame:CGRectMake(20, 240, 70, 70) ImageName:@"apple"];
    [self.view addSubview:moveView];
    
    CABasicAnimation *moveAnimation =[CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue =  [NSValue valueWithCGPoint:CGPointMake(40, 240)];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 240)];
    moveAnimation.duration =2;
    moveAnimation.repeatCount =INFINITY;
    moveAnimation.autoreverses =YES;//动画结束时是否进行逆动作
    [moveView.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
    
    /**------------------------背景颜色变化动画-----------------------------------*/
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(20, 310, 70, 70)];
    colorView.backgroundColor = [UIColor redColor];
    [self.view addSubview:colorView];
    
    CABasicAnimation *colorAnim =[CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnim.fromValue =(id)[UIColor redColor].CGColor;
    colorAnim.toValue = (id)[UIColor greenColor].CGColor;
    colorAnim.autoreverses = true;
    colorAnim.repeatCount = INFINITY;
    colorAnim.duration = 2;
    [colorView.layer addAnimation:colorAnim forKey:@"colorAnim"];
    
    /**------------------------内容变化动画-------------------------------------*/
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 310, 70, 70)];
    imageView.image = [UIImage imageNamed:@"apple"];
    [self.view addSubview:imageView];
    CABasicAnimation *contentsAnim = [CABasicAnimation animationWithKeyPath:@"contents"];
    contentsAnim.toValue = (id)[UIImage imageNamed:@"img_index_01bg"].CGImage;
    contentsAnim.duration = 2;
    contentsAnim.autoreverses = true;
    contentsAnim.repeatCount = INFINITY;
    [imageView.layer addAnimation:contentsAnim forKey:@"contentsAnim"];
    
    /**------------------------圆角变化动画-------------------------------------*/
    UIView *cornerRadiusView = [[UIView alloc] initWithFrame:CGRectMake(280, 310, 70, 70)];
    cornerRadiusView.backgroundColor = [UIColor redColor];
    [self.view addSubview:cornerRadiusView];
    //    cornerRadiusView.layer.masksToBounds = YES;
    CABasicAnimation *cornerRadiusAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerRadiusAnim.toValue = @(35);
    cornerRadiusAnim.duration = 2;
    cornerRadiusAnim.autoreverses = true;
    cornerRadiusAnim.repeatCount = INFINITY;
    [cornerRadiusView.layer addAnimation:cornerRadiusAnim forKey:@"cornerRadiusAnim"];
    
    /**------------------------比例缩放动画-------------------------------------*/
    UIView *scaleView = [[UIView alloc] initWithFrame:CGRectMake(20, 410, 70, 70)];
    scaleView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scaleView];
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @(0);
    scaleAnim.toValue = @(1);
    scaleAnim.duration = 2;
//    scaleAnim.autoreverses = YES;
    scaleAnim.repeatCount = INFINITY;
    [scaleView.layer addAnimation:scaleAnim forKey:@"scaleAnim"];

    
    /**------------------------比例缩放动画X-------------------------------------*/
    UIView *scaleViewX = [[UIView alloc] initWithFrame:CGRectMake(150, 410, 70, 70)];
    scaleViewX.backgroundColor = [UIColor redColor];
    [self.view addSubview:scaleViewX];
    CABasicAnimation *scaleAnimX = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleAnimX.fromValue = @(0);
    scaleAnimX.toValue = @(1);
    scaleAnimX.duration = 2;
//    scaleAnimX.autoreverses = YES;
    scaleAnimX.repeatCount = INFINITY;
    [scaleViewX.layer addAnimation:scaleAnimX forKey:@"scaleAnimX"];
    
    /**------------------------比例缩放动画Y-------------------------------------*/
    UIView *scaleViewY = [[UIView alloc] initWithFrame:CGRectMake(280, 410, 70, 70)];
    scaleViewY.backgroundColor = [UIColor redColor];
    [self.view addSubview:scaleViewY];
    CABasicAnimation *scaleAnimY = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleAnimY.fromValue = @(0);
    scaleAnimY.toValue = @(1);
    scaleAnimY.duration = 2;
//    scaleAnimY.autoreverses = YES;
    scaleAnimY.repeatCount = INFINITY;
    [scaleViewY.layer addAnimation:scaleAnimY forKey:@"scaleAnimY"];

    /**------------------------指定大小缩放-------------------------------------*/
    UIView *boundsView = [[UIView alloc] initWithFrame:CGRectMake(40, 520, 20, 80)];
    boundsView.backgroundColor = [UIColor redColor];
    [self.view addSubview:boundsView];
    CABasicAnimation *boundsAnim = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 100, 50)];
    boundsAnim.duration = 2;
//    boundsAnim.autoreverses = YES;
    boundsAnim.repeatCount = INFINITY;
    [boundsView.layer addAnimation:boundsAnim forKey:@"boundsAnim"];
    
    
    /**------------------------透明动画-------------------------------------*/
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(150, 520, 70, 70)];
    alphaView.backgroundColor = [UIColor redColor];
    [self.view addSubview:alphaView];
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue = @(0.3);
    alphaAnim.toValue = @(1);
    alphaAnim.duration = 1.5;
    alphaAnim.autoreverses = YES;
    alphaAnim.repeatCount = INFINITY;
    [alphaView.layer addAnimation:alphaAnim forKey:@"alphaAnim"];
    
    /**------------------------组合动画-------------------------------------*/
    UIView *groupView = [[UIView alloc] initWithFrame:CGRectMake(280, 520, 70, 70)];
//    groupView.backgroundColor = [UIColor redColor];
    [self.view addSubview:groupView];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:cornerRadiusAnim,rotationAnimZ,colorAnim, nil];
    group.duration = 2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; // 速度控制函数
    group.autoreverses = YES;
    group.repeatCount = INFINITY;
    [groupView.layer addAnimation:group forKey:@"group"];
    
}



@end
