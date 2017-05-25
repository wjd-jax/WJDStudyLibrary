//
//  JDContactsViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDContactsViewController.h"

@interface JDContactsViewController ()

@end

@implementation JDContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"IOS9之后",@"ClassName":@"JDNewContactViewController"},
                           @{@"title":@"IOS9之前",@"ClassName":@"JDNewContactViewController"},
                           
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
