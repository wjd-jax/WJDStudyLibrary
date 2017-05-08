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
    _imageView.backgroundColor =[UIColor blueColor];
    [self.contentView addSubview:_imageView];
}
-(void)setShop:(JDShopModel *)shop
{
    _shop = shop;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@""]];
}
@end
