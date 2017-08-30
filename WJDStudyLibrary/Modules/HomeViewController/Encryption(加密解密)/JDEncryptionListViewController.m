//
//  JDEncryptionListViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDEncryptionListViewController.h"

@interface JDEncryptionListViewController ()

@end

@implementation JDEncryptionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"加密解密",@"className":@"JDEvntyptionViewController"},
                           @{@"title":@"动态生成密钥对",@"className":@"KeyPairStoryboard"},
                           @{@"title":@"keyChain 存储用户名密码",@"className":@"JDKeyChianTestStoryboard"}];
    // Do any additional setup after loading the view.
}


@end
