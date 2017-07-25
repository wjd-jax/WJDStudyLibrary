//
//  JDGuideViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDGuideViewController.h"
#import "JDGuidePageViewController.h"

@interface JDGuideViewController ()
@property(nonatomic,retain)JDGuidePageViewController *gpvc;
@end

@implementation JDGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    NSArray *backgroundImageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    
    _gpvc =[[JDGuidePageViewController alloc]initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
//    _gpvc =[[JDGuidePageViewController alloc]initWithCoverImageNames:backgroundImageNames];
    [self.view addSubview:_gpvc.view];
    
    JDWeakSelf(self);
    _gpvc.didSelectedEnter = ^(){
//        weakself.view =nil;
        [weakself.navigationController popViewControllerAnimated:YES];
        weakself.navigationController.navigationBarHidden = NO;

    
    };
}

 

@end
