//
//  JDCardFlowLayout.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/2.
//  Copyright © 2017年 wangjundong. All rights reserved.
//
/*
 1）-(void)prepareLayout  设置layout的结构和初始需要的参数等。
 
 2)  -(CGSize) collectionViewContentSize 确定collectionView的所有内容的尺寸。
 
 3）-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect初始的layout的外观将由该方法返回的UICollectionViewLayoutAttributes来决定。
 
 4)在需要更新layout时，需要给当前layout发送
 1)-invalidateLayout， 该消息会立即返回，并且预约在下一个loop的时候刷新当前layout
 2)-prepareLayout，
 3)依次再调用-collectionViewContentSize和-layoutAttributesForElementsInRect来生成更新后的布局。
 
 */
#import "JDCardFlowLayout.h"

@implementation JDCardFlowLayout
{
    //    CGFloat previousOffset;
    //    CGFloat diffrence;
    
    NSIndexPath *mainIndexPath;         //正在消失或者显示的 item
    NSIndexPath *movingInIndexPath;     //将要消失或者显示的 item
}

//设置layout的结构和初始需要的参数等>>>1
- (void)prepareLayout
{
    [super prepareLayout];
    [self setupLayout];
}

//可以配置每个 item 的大小等属性,执行一次
- (void)setupLayout
{
    
    CGFloat inset  = self.collectionView.bounds.size.width * (6/64.0f);
    //向下舍入
    inset = floor(inset);
    
    self.itemSize = CGSizeMake(self.collectionView.bounds.size.width - (2 *inset), self.collectionView.bounds.size.height * 3/4);
    //上线左右的边界
    self.sectionInset = UIEdgeInsetsMake(0,inset, 0,inset);
    //设置滑动方向
    //self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}


//自定义布局必须YES
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
/*
 Attribute包含的属性
 @property (nonatomic) CGRect frame
 @property (nonatomic) CGPoint center
 @property (nonatomic) CGSize size
 @property (nonatomic) CATransform3D transform3D
 @property (nonatomic) CGFloat alpha
 @property (nonatomic) NSInteger zIndex
 @property (nonatomic, getter=isHidden) BOOL hidden
 */

//返回所有cell的布局属性
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    // 获取一组当前显示的cell们的indexPath的数组,这个数组也不一定只有一个元素,取第一个
    NSArray *cellIndices = [self.collectionView indexPathsForVisibleItems];
    
    //初始化的时候执行一次
    if(cellIndices.count == 0 )
    {
        return attributes;
    }
    //界面中只有一个 item 的时候(第一个或者最后一个)
    else if (cellIndices.count == 1)
    {
        mainIndexPath = cellIndices.firstObject;
        movingInIndexPath = nil;
        
    }
    //界面中存在两个 item
    else if(cellIndices.count > 1)
    {
        
        NSIndexPath *firstIndexPath = cellIndices.firstObject;
        if(firstIndexPath == mainIndexPath)
        {
            movingInIndexPath = cellIndices[1];
        }
        else
        {
            movingInIndexPath = cellIndices.firstObject;
            mainIndexPath = cellIndices[1];
        }
        
    }
    
    //    diffrence =  self.collectionView.contentOffset.x - previousOffset;
    //    previousOffset = self.collectionView.contentOffset.x;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes)
    {
        [self applyTransformToLayoutAttributes:attribute];
    }
    return  attributes;
}


//设置每个 item 的3D 动画方式
- (void)applyTransformToLayoutAttributes:(UICollectionViewLayoutAttributes *)attribute
{
    if(attribute.indexPath.section == mainIndexPath.section)
    {
        //将要消失的 item
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:mainIndexPath];
        attribute.transform3D = [self transformFromView:cell];
    }
    else if (attribute.indexPath.section == movingInIndexPath.section)
    {
        //将要显示的 item
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:movingInIndexPath];
        attribute.transform3D = [self transformFromView:cell];
    }
}




#pragma mark - Logica
- (CGFloat)baseOffsetForView:(UIView *)view
{
    
    UICollectionViewCell *cell = (UICollectionViewCell *)view;
    CGFloat offset =  ([self.collectionView indexPathForCell:cell].section) * self.collectionView.bounds.size.width;
    
    return offset;
}

- (CGFloat)heightOffsetForView:(UIView *)view
{
    CGFloat height;
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat scrollViewWidth = self.collectionView.bounds.size.width;
    //TODO:make this constant a certain proportion of the collection view
    height = 120 * (currentOffset - baseOffsetForCurrentView)/scrollViewWidth;
    if(height < 0 )
    {
        height = - 1 *height;
    }
    return height;
}

- (CGFloat)angleForView:(UIView *)view
{
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat scrollViewWidth = self.collectionView.bounds.size.width;
    CGFloat angle = (currentOffset - baseOffsetForCurrentView)/scrollViewWidth;
    return angle;
}

- (BOOL)xAxisForView:(UIView *)view
{
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat offset = (currentOffset - baseOffsetForCurrentView);
    if(offset >= 0)
    {
        return YES;
    }
    return NO;
    
}

#pragma mark - Transform Related Calculation
- (CATransform3D)transformFromView:(UIView *)view
{
    CGFloat angle = [self angleForView:view];
    CGFloat height = [self heightOffsetForView:view];
    BOOL xAxis = [self xAxisForView:view];
    return [self transformfromAngle:angle height:height xAxis:xAxis];
}

- (CATransform3D)transformfromAngle:(CGFloat )angle height:(CGFloat) height xAxis:(BOOL)axis
{
    CATransform3D t = CATransform3DIdentity;
    t.m34  = 1.0/-500;
    
    if (axis)
        
        t = CATransform3DRotate(t,angle, 1, 1, 0);
    
    else
        
        t = CATransform3DRotate(t,angle, -1, 1, 0);
    
    //      t = CATransform3DTranslate(t, 0, height, 0);
    
    return t;
}



//返回每个cell的布局属性
//测试得出shouldInvalidateLayoutForBoundsChange返回 NO 的时候以下方法不执行

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applyTransformToLayoutAttributes:attributes];
    return attributes;
}






@end
