//
//  JDSystemTransAnimationViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDSystemTransAnimationViewController.h"
#import "JDSystemTransTestViewController.h"
typedef NS_ENUM(NSInteger,PushType) {
    Type_Push,
    Type_Present
};


@interface JDSystemTransAnimationViewController ()

@property(nonatomic,retain)NSArray *typeArray;
@property(nonatomic,assign)PushType pushType;

@end

@implementation JDSystemTransAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pushType = Type_Push;
    
    UIBarButtonItem *rightBarItem =[JDUtils createTextBarButtonWithTitle:@"转场类型" Target:self Action:@selector(rightBarItemClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _typeArray = @[
                   @"fade",     //淡入淡出	kCATransitionFade
                   @"push",     //推挤	kCATransitionPush
                   @"reveal",	//揭开	kCATransitionReveal
                   @"moveIn",	//覆盖	kCATransitionMoveIn
                   @"cube",     //立方体	私有API
                   @"suckEffect",	//吮吸	私有API
                   @"oglFlip",      //翻转	私有API
                   @"rippleEffect",	//波纹	私有API
                   @"pageCurl",     //反翻页	私有API
                   @"cameraIrisHollowOpen",     //开镜头	私有API
                   @"cameraIrisHollowClose",	//关镜头	私有API
                   ];
    
    
    self.dataSoureArray =@[
                           @{@"title":@"淡入淡出",@"className":@"fade"},
                           @{@"title":@"推挤",@"className":@"push"},
                           @{@"title":@"揭开",@"className":@"reveal"},
                           @{@"title":@"覆盖",@"className":@"moveIn"},
                           @{@"title":@"立方体",@"className":@"cube"},
                           @{@"title":@"吮吸",@"className":@"suckEffect"},
                           @{@"title":@"翻转",@"className":@"oglFlip"},
                           @{@"title":@"波纹",@"className":@"rippleEffect"},
                           @{@"title":@"反翻页",@"className":@"pageCurl"},
                           @{@"title":@"开镜头",@"className":@"cameraIrisHollowOpen"},
                           @{@"title":@"关镜头",@"className":@"cameraIrisHollowClose"},
                           
                           ];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDSystemTransTestViewController *vc =[[JDSystemTransTestViewController alloc]init];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = [_typeArray objectAtIndex:indexPath.row];
    animation.subtype = kCATransitionFromRight;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    
    if (_pushType ==Type_Push) {
        
        [self.navigationController pushViewController:vc animated:NO];
    }
    else
        //注意以下方法必须animated设置NO,而且返回的动画还是默认的
        [self presentViewController:vc animated:NO completion:nil];
    
}

- (void)rightBarItemClick {
    
    UIAlertController *altVC =[UIAlertController alertControllerWithTitle:@"选择转场类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"push" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _pushType = Type_Push;
    }];
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"present" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _pushType = Type_Present;
        
    }];
    [altVC addAction:act1];
    [altVC addAction:act2];
    [self presentViewController:altVC animated:YES completion:nil];
}



@end
