//
//  JDShowTableViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/9/19.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDShowTableViewController.h"
#import "JDTableViewAnimationListController.h"

@interface JDShowTableViewController ()

@end

@implementation JDShowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSoureArray = @[@{@"title":@"左侧飞出",@"className":@""},
                            @{@"title":@"下落渐显",@"className":@""},
                            @{@"title":@"快速下落",@"className":@""},
                            @{@"title":@"左右出现",@"className":@""},
                            @{@"title":@"翻转出现",@"className":@""},
                            @{@"title":@"飞到顶端",@"className":@""},
                            @{@"title":@"跳动下落",@"className":@""},
                            @{@"title":@"向上靠拢",@"className":@""},
                            
                            ];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JDTableViewAnimationListController *vc = [[JDTableViewAnimationListController alloc] init];
    vc.index = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
