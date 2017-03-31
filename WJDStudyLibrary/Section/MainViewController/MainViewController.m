//
//  MainViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "MainViewController.h"
#import "ArrayDataSource.h"
#import "JDMainDataModel.h"

@interface MainViewController ()<UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSArray *titleArray;
@property(nonatomic,retain)ArrayDataSource *arrayDataSource;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self createUI];
    // Do any additional setup after loading the view.
}

static NSString *tableViewCellIdentifer = @"TableViewCellID";
- (void)createUI
{
    
    NSArray *dataArray =@[@{@"title":@"知识大全",@"ClassName":@"JDKnowledgeViewController"},
                          @{@"title":@"第二行",@"ClassName":@"第一行"},
                          @{@"title":@"第三行",@"ClassName":@"第一行"}];
    _titleArray =[JDMainDataModel mj_objectArrayWithKeyValuesArray:dataArray];

    _tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewCellIdentifer];
    _tableView.tableFooterView =[[UIView alloc]init];
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    
    void (^configureCell)(UITableViewCell*, JDMainDataModel *) = ^(UITableViewCell* cell, JDMainDataModel *model) {
        cell.textLabel.text =model.title;
    };
    _arrayDataSource = [[ArrayDataSource alloc] initWithItems:_titleArray cellIdentifier:tableViewCellIdentifer configureCellBlock:configureCell];
    self.tableView.dataSource = _arrayDataSource;
   
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    JDMainDataModel *model =[_titleArray objectAtIndex:indexPath.row];
    UIViewController *vc =[[NSClassFromString(model.ClassName) alloc] init];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
