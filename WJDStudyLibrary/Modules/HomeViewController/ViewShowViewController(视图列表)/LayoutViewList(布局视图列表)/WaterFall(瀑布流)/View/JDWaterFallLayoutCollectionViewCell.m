//
//  JDWaterFallLayoutCollectionViewCell.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDWaterFallLayoutCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface JDWaterFallLayoutCollectionViewCell ()
@property(nonatomic,retain)UIImageView *imageView;
@end
@implementation JDWaterFallLayoutCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
    
}


- (void)createUI {
    
    _imageView =[[UIImageView alloc]initWithFrame:self.contentView.bounds];
    
    [self.contentView addSubview:_imageView];
}

-(void)setShop:(JDShopModel *)shop
{
    _shop = shop;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@""]];
    
    //这一点很重要写成self.contentView.bounds会出错,用 nib约束 文件则不用写
    _imageView.frame = self.bounds;
    
}
@end
