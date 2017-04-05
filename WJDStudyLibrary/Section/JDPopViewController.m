//
//  JDPopViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDPopViewController.h"
#import "ArrayDataSource.h"
#import "JDMainDataModel.h"
#import "JDPopView.h"
#import "JDMessageView.h"
#import "JDAletView.h"


@interface JDPopViewController ()<UITableViewDelegate>

@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)ArrayDataSource *dataSource;
@end
@implementation JDPopViewController

static NSString *tableViewCellIdentifer = @"TableViewCellID";


-(void)viewDidLoad
{
    [self initData];
    
    [self createUI];
}
- (void)initData
{
    
    _dataArray =@[@"通用分享弹出视图",
                  @"仿QQ导航栏弹出提示框",
                  @"自定义AletView"];
    
}
- (void)createUI
{
    _tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellIdentifer];
    
    void (^configureCell)(UITableViewCell*, NSString *) = ^(UITableViewCell* cell, NSString *title) {
        cell.textLabel.text =title;
    };
    _dataSource =[[ArrayDataSource alloc]initWithItems:_dataArray cellIdentifier:tableViewCellIdentifer configureCellBlock:configureCell];
    _tableView.dataSource =_dataSource;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
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
        }
            break;
        default:
            break;
    }
    
}


@end
