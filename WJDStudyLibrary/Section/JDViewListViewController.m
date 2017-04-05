//
//  JDViewListViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//


#import "JDViewListViewController.h"
#import "ArrayDataSource.h"
#import "JDMainDataModel.h"


@interface JDViewListViewController ()<UITableViewDelegate>

@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)ArrayDataSource *dataSource;
@end
@implementation JDViewListViewController

static NSString *tableViewCellIdentifer = @"TableViewCellID";


-(void)viewDidLoad
{
    [self initData];

    [self createUI];
}
- (void)initData
{
    
    NSArray *dataArray =@[@{@"title":@"弹出视图",@"ClassName":@"JDPopViewController"},
                         ];
    _dataArray =[JDMainDataModel mj_objectArrayWithKeyValuesArray:dataArray];

}
- (void)createUI
{
    _tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellIdentifer];

    void (^configureCell)(UITableViewCell*, JDMainDataModel *) = ^(UITableViewCell* cell, JDMainDataModel *model) {
        cell.textLabel.text =model.title;
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
    JDMainDataModel *model =[_dataArray objectAtIndex:indexPath.row];
    UIViewController *vc =[[NSClassFromString(model.ClassName) alloc] init];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
