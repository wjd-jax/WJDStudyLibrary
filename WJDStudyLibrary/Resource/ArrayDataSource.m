//
//  ArrayDataSource.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "ArrayDataSource.h"

@interface ArrayDataSource ()

@property(nonatomic,retain)NSArray *items;
@property(nonatomic,copy)NSString *cellIdentifier;
@property(nonatomic,copy)configureCell configureCellBlock;
@end

@implementation ArrayDataSource
-(instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(configureCell)configureCellBlock
{
    self = [super init];
    if (self) {
        _items =items;
        _cellIdentifier =identifier;
        _configureCellBlock =configureCellBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [_items objectAtIndex:indexPath.row];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier
                                              forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    _configureCellBlock(cell,item);
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}


@end
