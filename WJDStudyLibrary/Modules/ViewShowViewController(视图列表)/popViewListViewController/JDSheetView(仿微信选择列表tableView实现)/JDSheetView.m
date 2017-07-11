//
//  JDSheetView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//


#import "JDSheetView.h"

static CGFloat const kXCellHeight = 50.0;
static CGFloat const kXHeaderViewHeight = 5.0;
static NSTimeInterval const kAnimationDuration = 0.3;

@interface JDSheetView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *items;
@property (nonatomic, copy) JDSheetViewDidSelectRowBlock didSelectRowBlock;
@property (nonatomic, assign) CGRect tableViewHideFrame;
@property (nonatomic, assign) CGRect tableViewShowFrame;

@end

@implementation JDSheetView

+ (void)ShowListWithItems:(NSArray<NSString *> *)titleItem didSelectRowBlock:(JDSheetViewDidSelectRowBlock)callBlock
{
    JDSheetView *view =[[JDSheetView alloc]initWithItems:titleItem didSelectRowBlock:callBlock];
    [view show];
}

- (instancetype)initWithItems:(NSArray<NSString *> *)titleItem didSelectRowBlock:(JDSheetViewDidSelectRowBlock)callBlock
{
    self =[super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _items = titleItem;
        _didSelectRowBlock = callBlock;
        [self createUI];
    }
    return self;
    
}

- (void)createUI {
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    CGFloat tableViewHeight = [self getTableViewHeight];
    _tableViewHideFrame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), tableViewHeight);
    _tableViewShowFrame = CGRectMake(0, CGRectGetHeight(self.bounds) - tableViewHeight, CGRectGetWidth(self.bounds), tableViewHeight);
    [self addSubview:self.tableView];
    self.tableView.frame = _tableViewHideFrame;
    
}

- (void)show
{
    
    if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    self.alpha = 0;
    [UIView animateWithDuration:kAnimationDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
        self.tableView.frame = _tableViewShowFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0;
        self.tableView.frame = _tableViewHideFrame;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hide];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.items.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : kXHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kXHeaderViewHeight)];
    view.backgroundColor = self.tableView.separatorColor;
    return view;
}

static NSString *const kXFJCategoryViewCellIdentifier = @"JDCategoryViewCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kXFJCategoryViewCellIdentifier forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.items[indexPath.row];
    } else {
        cell.textLabel.text = @"取消";
    }
    
    return cell;
}

//cell分割线处理
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.didSelectRowBlock) {
            
            self.didSelectRowBlock(indexPath.row);
        }
    }
    [self hide];
}

#pragma mark - getter & setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.alwaysBounceVertical = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = kXCellHeight;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kXFJCategoryViewCellIdentifier];
    }
    return _tableView;
}
- (CGFloat)getTableViewHeight {
    return self.items.count * kXCellHeight + kXHeaderViewHeight + kXCellHeight;
}

@end
