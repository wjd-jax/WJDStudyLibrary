//
//  JDOCRViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDOCRViewController.h"

@interface JDOCRViewController ()

@end

@implementation JDOCRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"银行卡识别",@"className":@"JDBankScanViewController"},
                           @{@"title":@"身份证识别",@"className":@"JDIDCardScanViewController"},

                           ];
}

@end
