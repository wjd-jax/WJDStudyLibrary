//
//  JDAutoLayoutCellViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/3.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDAutoLayoutCellViewController.h"
#import "ArrayDataSource.h"
#import "AutoLayoutTableViewCell.h"

/*
 自定义UILabel的numeLine设置为0
 设置约束.
 
 实现代理方法.
 - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
 
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 */

@interface JDAutoLayoutCellViewController ()<UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)ArrayDataSource *dataSource;
@property(nonatomic,retain)NSArray *dataArray;

@end

@implementation JDAutoLayoutCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


static NSString *tableViewCellIdentifer = @"HYHActiveSignUpListTableViewCellID";
- (void)createUI
{
    _dataArray = @[@"都会放假时间发货的健康生活打法就是快回家考虑地方哈的就是罚款",
                   @"缴费基数大幅度申报表就vjdfvb部分经费vjfdjvhjshvsdhfjh大家发客户数量的合法化书法家哈就是考虑换房间卡还是放到了季后赛的福建省地方就拉倒还是发了山东科技地方哈老师复健科 ",
                   @"附近开了个哈哈告诉老公还是反对韩国联合发生的概率梵蒂冈梵蒂冈回家考虑很多房间开老虎机放的海外机构获得数理化v",
                   @"会计师覆盖率高环境发生的概率会飞的建立工会法律后果就流口水范德华力客观环境十分肯定会更加克劳福德伙伴们傻逼女没办法什么VB,想不出,再不出现女买不起房hi胡睿服务而环境违法及",
                   @"房间都是老大赶紧来核实登记管理科",
                   @"房间管理会使肌肤换句话说发动机号结构化发动机和国家粉丝狂欢节开工日户籍开房vf文件和高科技风科技的监控回复接电话数据备份 服务为费而非 违反而非让我费而无法维尔康废物废物胡椒粉和覅偶打算覅较大四房电话覅简单撒批发价搜反扒十分骄傲圣诞节哦IE局  "
                   ];
    _tableView =[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"AutoLayoutTableViewCell" bundle:nil] forCellReuseIdentifier:tableViewCellIdentifer];
    
    _dataSource =[[ArrayDataSource alloc]initWithItems:_dataArray cellIdentifier:tableViewCellIdentifer configureCellBlock:^(AutoLayoutTableViewCell *cell, NSString *item) {
        cell.Label.text = item;
    }];
    
    _tableView.tableFooterView =[[UIView alloc]init];
    _tableView.delegate =self;
    _tableView.dataSource =_dataSource;
    
    [self.view addSubview:_tableView];
    
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[_tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifer];
    return cell;
}

#pragma mark - UITableViewDelegate

//以下两个方法必须实现.才能实现cell高度自适应
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
