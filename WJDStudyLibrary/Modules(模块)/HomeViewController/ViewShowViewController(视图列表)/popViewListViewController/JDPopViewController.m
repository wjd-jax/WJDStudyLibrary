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
#import "JDSheetView.h"
#import "JDHubMessageView.h"

@implementation JDPopViewController

static NSString *tableViewCellIdentifer = @"TableViewCellID";


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"通用分享弹出视图",@"className":@""},
                           @{@"title":@"仿QQ导航栏弹出提示框",@"className":@""},
                           @{@"title":@"自定义AletView",@"className":@""},
                           @{@"title":@"状态栏提示框",@"className":@""},
                           @{@"title":@"仿微信弹出列表视图",@"className":@""},
                           @{@"title":@"仿微信弹出列表视图(tableView实现)",@"className":@""},
                            @{@"title":@"简单屏幕提示",@"className":@""},
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
        case 5:
        {
            [JDSheetView ShowListWithItems:@[@"选择1",@"选择2"] didSelectRowBlock:^(NSUInteger index) {
                
            }];
        }
            break;
            
        case 6:
        {
            [JDHubMessageView showMessage:@"这是提示消息"];
        }
            break;
        default:
            break;
    }
    
}


@end
