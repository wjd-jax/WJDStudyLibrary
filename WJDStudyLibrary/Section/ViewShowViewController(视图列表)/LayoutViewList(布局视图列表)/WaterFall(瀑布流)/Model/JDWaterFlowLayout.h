//
//  JDWaterFlowLayout.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDWaterFlowLayout;

@protocol JDWaterflowLayoutDelegate <NSObject>

- (CGFloat)waterflowLayout:(JDWaterFlowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional

/**
 *  返回四边的间距, 默认是UIEdgeInsetsMake(10, 10, 10, 10)
 */
- (UIEdgeInsets)insetsInWaterflowLayout:(JDWaterFlowLayout *)waterflowLayout;
/**
 *  返回最大的列数, 默认是3
 */
- (int)maxColumnsInWaterflowLayout:(JDWaterFlowLayout *)waterflowLayout;
/**
 *  返回每行的间距, 默认是10
 */
- (CGFloat)rowMarginInWaterflowLayout:(JDWaterFlowLayout *)waterflowLayout;
/**
 *  返回每列的间距, 默认是10
 */
- (CGFloat)columnMarginInWaterflowLayout:(JDWaterFlowLayout *)waterflowLayout;

@end

@interface JDWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<JDWaterflowLayoutDelegate> delegate;


@end
