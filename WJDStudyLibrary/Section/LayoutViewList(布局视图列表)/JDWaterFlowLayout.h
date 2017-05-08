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

@end

@interface JDWaterFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<JDWaterflowLayoutDelegate> delegate;


@end
