//
//  JDWaterFallLayoutViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDWaterFallLayoutViewController.h"
#import "MJExtension.h"
#import "JDShopModel.h"
#import "JDWaterFlowLayout.h"
#import "JDWaterFallLayoutCollectionViewCell.h"
#import "YFShopCell.h"

static NSString * const CellId = @"shop";

@interface JDWaterFallLayoutViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,JDWaterflowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UICollectionView *collectionView;


@end

@implementation JDWaterFallLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"流水布局展示";
    [self.dataArray addObjectsFromArray:[JDShopModel mj_objectArrayWithFilename:@"1.plist"]];
    
    JDWaterFlowLayout *layout =[[JDWaterFlowLayout alloc]init];
    layout.delegate =self;
    
    UICollectionView *collectionView =[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.delegate =self;
    collectionView.dataSource =self;
    collectionView.backgroundColor =[UIColor whiteColor];
    [collectionView registerClass:[JDWaterFallLayoutCollectionViewCell class] forCellWithReuseIdentifier:CellId];
//    [collectionView registerNib:[UINib nibWithNibName:@"YFShopCell" bundle:nil] forCellWithReuseIdentifier:CellId];

    [self.view addSubview:collectionView];
    
    _collectionView =collectionView;
    

}
#pragma mark - <UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDWaterFallLayoutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    cell.shop = self.dataArray[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;

}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"点击了");
}

#pragma mark - <YFWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(JDWaterFlowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    JDShopModel *shop = self.dataArray[indexPath.item];
    return shop.h/shop.w * itemWidth ;
}


//初始化数据,如果数据源不存在,自动初始化
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
