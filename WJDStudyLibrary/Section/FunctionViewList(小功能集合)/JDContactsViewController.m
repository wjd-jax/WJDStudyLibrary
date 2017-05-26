//
//  JDNewContactViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDContactsViewController.h"
#import "JDContactManager.h"
#import "ArrayDataSource.h"

@interface JDContactsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)ArrayDataSource *arrayDataSource;
@property(nonatomic,retain)NSArray *dataArray;

@end

static NSString *cellIdentifier = @"CellIdentifier";

@implementation JDContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButton =[JDUtils createTextBarButtonWithTitle:@"通讯录" Target:self Action:@selector(requestContact)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    _arrayDataSource =[[ArrayDataSource alloc]initWithItems:_dataArray cellIdentifier:cellIdentifier configureCellBlock:^(UITableViewCell *cell, id model) {
        
    }];
    
    _tableView.dataSource = _arrayDataSource;
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - click
- (void)requestContact
{
    JDContactManager *manager =[JDContactManager manager];
//    [manager presentContactUIWithViewController:self];
}

-(void)dealloc
{
    
}
@end
