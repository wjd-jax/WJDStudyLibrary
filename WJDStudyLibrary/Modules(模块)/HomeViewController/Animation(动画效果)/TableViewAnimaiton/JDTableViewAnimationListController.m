//
//  JDTableViewAnimationListController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/9/19.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDTableViewAnimationListController.h"
#import "TableViewAnimationKitHeaders.h"

@interface JDTableViewAnimationListController ()
@property (nonatomic, assign) NSInteger cellNum;
@end

@implementation JDTableViewAnimationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.navigationItem.rightBarButtonItem = [JDUtils createTextBarButtonWithTitle:@"Again" Target:self Action:@selector(loadData)];
}

- (void)loadData {
    
    _cellNum = 15;
    [self.tableView reloadData];
    [self starAnimationWithTableView:self.tableView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        CGFloat width = [[UIScreen mainScreen] bounds].size.width - 40;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 10, width, 80)];
        view.backgroundColor = [UIColor orangeColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 9.0;
        [cell.contentView addSubview:view];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)starAnimationWithTableView:(UITableView *)tableView {
    
    [TableViewAnimationKit showWithAnimationType:self.index tableView:tableView];
}


@end
