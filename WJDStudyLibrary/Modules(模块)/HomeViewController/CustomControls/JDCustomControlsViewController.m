//
//  JDCustomControlsViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCustomControlsViewController.h"

@interface JDCustomControlsViewController ()

@end

@implementation JDCustomControlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[
                           @{@"title":@"标签",@"className":@"JDCustomLabelViewController"},
                           @{@"title":@"按钮",@"className":@"JDCustomButtonListViewController"},
                           ];
    
}

 

@end
