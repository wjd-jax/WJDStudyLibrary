//
//  JDPopViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDPopViewController.h"
#import "JDMainDataModel.h"
#import "JDPopView.h"
#import "JDMessageView.h"
#import "JDAletView.h"
#import "JDStatusBarMessageView.h"
#import "JDActionSheetView.h"

@implementation JDPopViewController

static NSString *tableViewCellIdentifer = @"TableViewCellID";


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"通用分享弹出视图",@"ClassName":@""},
                           @{@"title":@"仿QQ导航栏弹出提示框",@"ClassName":@""},
                           @{@"title":@"自定义AletView",@"ClassName":@""},
                           @{@"title":@"状态栏提示框",@"ClassName":@""},
                           @{@"title":@"仿微信弹出列表视图",@"ClassName":@""},
                           
                           ];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
            case 0:
        {
            JDPopView *popView =[[JDPopView alloc]init];
            [popView showWithBlock:^(id callBack) {
                DLog(@"%@", callBack);
            }];
        }
            break;
            case 1:
        {
            [JDMessageView showMessage:@"这是一个提示哦"];
        }
            break;
            case 2:
        {
            JDAletView *aletView =[[JDAletView alloc]initWithTitle:@"标题" detailMessage:@"详细描述" callBack:^(NSInteger index) {
                
            } ];
            [aletView show];
            break;

        }
            case 3:
        {
            [JDStatusBarMessageView showMessage:@"这是一个提示哦"];

        }
            break;
        case 4:
        {
            [JDActionSheetView showActionSheetWithTitle:@"标题" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@[@"选择1",@"选择2"] handler:^(JDActionSheetView *actionSheet, NSInteger index) {
                
            }];
        }
            break;
        default:
            break;
    }
    
}


@end
