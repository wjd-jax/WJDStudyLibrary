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

- (void)setDataSourceArray:(NSArray *)arry;
{
    _items = arry;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [_items objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    
    //如果是自定义的cell必须在原来的tablView处调用
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:mainCellIdentifier];
    //否则会无法执行自定义cell的方法
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_cellIdentifier];
    }
    id item = [self itemAtIndexPath:indexPath];
    _configureCellBlock(cell,item);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}


@end
