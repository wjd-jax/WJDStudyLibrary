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
//  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mainCellIdentifier];
    
}
- (void)setDataSoureArray:(NSArray *)dataSoureArray
{
    _dataArray =[JDMainDataModel mj_objectArrayWithKeyValuesArray:dataSoureArray];
    void (^configureCell)(UITableViewCell*, JDMainDataModel *) = ^(UITableViewCell* cell, JDMainDataModel *model) {

        cell.textLabel.text =model.title;
        cell.detailTextLabel.text =model.ClassName;
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
    
    UIViewController *vc =[[NSClassFromString(model.ClassName) alloc] init];
    vc.title =model.title;
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSRange range;
    range = [model.ClassName rangeOfString:@"Storyboard"];
    if (range.location != NSNotFound) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:model.ClassName bundle:nil];
        
        UIViewController  *cardVC = [storyBoard instantiateViewControllerWithIdentifier:model.ClassName];
        if (cardVC) {
            cardVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:cardVC animated:YES];
            
        }
    }
    else{
    }
    
    
}


@end
