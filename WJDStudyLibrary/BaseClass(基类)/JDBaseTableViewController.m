//
//  JDBaseTableViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDBaseTableViewController.h"
#import "ArrayDataSource.h"

const int cellHeight = 60;

@interface JDBaseTableViewController ()

@property(nonatomic,retain)ArrayDataSource *arrayDataSource;
@end

static NSString *mainCellIdentifier = @"mainCellIdentifier";

@implementation JDBaseTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //cell分割线向左移动15像素
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
//  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mainCellIdentifier];
    
}
- (void)setDataSoureArray:(NSArray *)dataSoureArray
{
    _dataArray =[JDMainDataModel mj_objectArrayWithKeyValuesArray:dataSoureArray];
    void (^configureCell)(UITableViewCell*, JDMainDataModel *) = ^(UITableViewCell* cell, JDMainDataModel *model) {

        cell.textLabel.text =model.title;
        cell.detailTextLabel.text =model.className;
        cell.contentView.backgroundColor =JDRandomColor;
        
    };
    _arrayDataSource = [[ArrayDataSource alloc] initWithItems:_dataArray cellIdentifier:mainCellIdentifier configureCellBlock:configureCell];
    self.tableView.dataSource = _arrayDataSource;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JDMainDataModel *model =[_dataArray objectAtIndex:indexPath.row];
    
    UIViewController *vc =[[NSClassFromString(model.className) alloc] init];
    vc.title =model.title;
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSRange range;
    range = [model.className rangeOfString:@"Storyboard"];
    if (range.location != NSNotFound) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:model.className bundle:nil];
        
        UIViewController  *cardVC = [storyBoard instantiateViewControllerWithIdentifier:model.className];
        if (cardVC) {
            cardVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:cardVC animated:YES];
            
        }
    }
    else{
    }
    
    
}


@end
