//
//  JDCodeImageViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/8.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCodeImageViewController.h"

@interface JDCodeImageViewController ()

@end

@implementation JDCodeImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"二维码和条形码生成",@"className":@"QRImageStoryboard"},
                           @{@"title":@"二维码扫描",@"className":@"JDQRScannerViewController"},
                           ];
    
}

@end
