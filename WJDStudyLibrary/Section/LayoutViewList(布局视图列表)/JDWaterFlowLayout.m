//
//  JDWaterFlowLayout.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDWaterFlowLayout.h"

static const int JDDefaultMaxColumns = 2;                       /** 每一行的最大列数 */
static const CGFloat JDDefaultRowMargin = 10;                   /** 每一行的间距 */
static const CGFloat JDDefaultColumnMargin = 10;                /** 每一列的间距 */
static const UIEdgeInsets JDDefaultInsets = {10, 10, 10, 10};   /** 上下左右的间距 */

@interface JDWaterFlowLayout ()

@property (nonatomic, strong) NSMutableArray *attrsArray;
@property (nonatomic, strong) NSMutableArray *maxYs;            //存放每一列的最大Y值(整体高度)

@end

@implementation JDWaterFlowLayout

#pragma mark - 初始化

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

- (NSMutableArray *)maxYs
{
    if (!_maxYs) {
        self.maxYs = [[NSMutableArray alloc] init];
    }
    return _maxYs;
}

#pragma mark - 重要方法1:设置layout的结构和初始需要的参数等

//只执行一次
- (void)prepareLayout{
    
    // 初始化最大y值数组
    [self.maxYs removeAllObjects];
    int maxColumns = self.maxColumns;
    
    for (NSUInteger i = 0; i < maxColumns; i++) {
        [self.maxYs addObject:@(self.insets.top)];
    }
    
    [self.attrsArray removeAllObjects];

    // 计算所有cell的布局属性
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSUInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
        
    }
    
}
/**
 *  如果返回YES, 当显示的范围发生改变时就会重新刷新
 */
#pragma mark - 重要方法2:开启自定义布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
#pragma mark - 重要方法3:返回所有cell布局属性的数组

//返回所有cell的布局属性,会执行多次
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //此数组在prepareLayout中已经生成
    return self.attrsArray;
}

//确定collectionView的所有内容的尺寸。
- (CGSize)collectionViewContentSize
{
    CGFloat longMaxY = 0;
    if (self.maxYs.count) {
        
        longMaxY = [self.maxYs[0] doubleValue]; // 最长那一列 的 最大Y值
        for (int i = 1; i < self.maxColumns; i++) {
            
            CGFloat maxY = [self.maxYs[i] doubleValue];
            longMaxY =maxY>longMaxY?maxY:longMaxY;
            
        }
        
        // 累加底部的间距
        longMaxY += self.insets.bottom;
    }
    return CGSizeMake(0, longMaxY);
}

/**
 *  indexPath这个位置对应cell的布局属性
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat columnMargin = self.columnMargin;                       // 每一列之间的间距
    CGFloat rowMargin = self.rowMargin;                             // 每一行之间的间距
    
    int maxColumns = self.maxColumns;                               // 每一行的最大列数
    UIEdgeInsets insets = self.insets;                              // 边界
    
    CGFloat collectionW = self.collectionView.bounds.size.width;    // CollectionView的尺寸
    
    // item(cell)的宽度
    CGFloat contentW = collectionW - insets.left - insets.right - (maxColumns - 1) * columnMargin;
    CGFloat itemW = contentW/maxColumns;
    CGFloat itemH = [self.delegate waterflowLayout:self heightForItemAtIndexPath:indexPath itemWidth:itemW];
    
    
    // 设置位置和尺寸
    CGFloat minMaxY = [[self.maxYs firstObject] floatValue];        // 最短那一列 的 最大Y值
    int minColumn = 0;                                              // 最短那一列 的 列号
    for (int i = 1; i < maxColumns; i++) {
        
        CGFloat maxY = [self.maxYs[i] floatValue];
        
        if (maxY < minMaxY) {
            minMaxY = maxY;
            minColumn = i;
        }
    }
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGFloat itemX = insets.left + minColumn * (itemW + columnMargin);
    CGFloat itemY = minMaxY + rowMargin;
    
    attrs.frame = CGRectMake(itemX, itemY, itemW, itemH);
    self.maxYs[minColumn] = @(CGRectGetMaxY(attrs.frame));          // 累加这一列的最大Y值
    
    return attrs;
}

#pragma mark - 私有方法(获得代理返回的数字)

- (int)maxColumns
{
    if ([self.delegate respondsToSelector:@selector(maxColumnsInWaterflowLayout:)]) {
        return [self.delegate maxColumnsInWaterflowLayout:self];
    }

    return JDDefaultMaxColumns;
}

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    }

    return JDDefaultRowMargin;
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    }

    return JDDefaultColumnMargin;
}

- (UIEdgeInsets)insets
{
    if ([self.delegate respondsToSelector:@selector(insetsInWaterflowLayout:)]) {
        return [self.delegate insetsInWaterflowLayout:self];
    }
    return JDDefaultInsets;
}

@end
