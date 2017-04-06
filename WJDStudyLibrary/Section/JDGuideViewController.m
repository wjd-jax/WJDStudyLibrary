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
    
//    _gpvc =[[JDGuidePageViewController alloc]initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
    _gpvc =[[JDGuidePageViewController alloc]initWithCoverImageNames:backgroundImageNames];
    [self.view addSubview:_gpvc.view];
    
    JDWeakSelf(self);
    _gpvc.didSelectedEnter = ^(){
        weakself.view =nil;
        weakself.navigationController.navigationBarHidden = NO;
    
    };
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
