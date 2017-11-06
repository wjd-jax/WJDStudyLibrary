//
//  JDGitHubListTableViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/8/30.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDGitHubListTableViewController.h"
#import "JDWebBrowserViewController.h"

@interface JDGitHubListTableViewController ()

@end

@implementation JDGitHubListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSoureArray = @[
                            @{@"title":@"PureCamera",@"className":@"拍照完整可以自由裁剪",@"info":@"https://github.com/wubianxiaoxian/PureCamera-Demo/blob/master/README.md"},
                            
                            @{@"title":@"TZImagePickerController",@"className":@"一个支持多选、选原图和视频的图片选择器，同时有预览、裁剪功能",@"info":@"https://github.com/banchichen/TZImagePickerController/blob/master/README.md"},
                            
                            @{@"title":@"LBXScan",@"className":@"二维码、扫码、扫一扫、ZXing、ZBar、iOS系统AVFoundation扫码封装，扫码界面效果封装",@"info":@"https://github.com/MxABC/LBXScan/blob/master/README.md"},
                            
                            @{@"title":@"IQKeyboardManager",@"className":@"Codeless drop-in universal library allows to prevent issues of keyboard sliding up and cover UITextField/UITextView. Neither need to write any code nor any setup required and much more.",@"info":@"https://github.com/hackiftekhar/IQKeyboardManager/blob/master/README.md"},
                            
                            @{@"title":@"SDCycleScrollView",@"className":@"C无限循环图片、文字轮播器。",@"info":@"https://github.com/gsdios/SDCycleScrollView/blob/master/README.md"},
                            
                            @{@"title":@"PPBadgeView",@"className":@"iOS自定义Badge组件, 支持UIView, UITabBarItem, UIBarButtonItem",@"info":@"https://github.com/jkpang/PPBadgeView/blob/master/README.md"},
                       
                            @{@"title":@"iCarousel",@"className":@"A simple, highly customisable, data-driven 3D carousel for iOS and Mac OS",@"info":@"https://github.com/nicklockwood/iCarousel/blob/master/README.md"},
                            
                            ];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDMainDataModel *model =  self.dataArray[indexPath.row];
    [JDWebBrowserViewController openUrl:model.info fromViewController:self];
}

@end
