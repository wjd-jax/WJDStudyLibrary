//
//  MSCTakePictureView.m
//  MSCIDPhotoDemo
//
//  Created by miaoshichang on 2017/6/22.
//  Copyright © 2017年 miaoshichang. All rights reserved.
//

#import "MSCTakePictureView.h"

@interface MSCTakePictureView ()

@property (nonatomic, strong)UILabel *titleLabel;

@end


@implementation MSCTakePictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeupUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeupUI];
    }
    return self;
}

- (void)makeupUI
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.bounds.size.width-160)/2.f, 20, 160, 40)];
    self.titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.titleLabel.textColor = [UIColor colorWithRed:0xff/255.f green:0xbc/255.f blue:0x2e/255.f alpha:1];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.layer.cornerRadius = 4.f;
    self.titleLabel.clipsToBounds = YES;
    self.titleLabel.text = @"请水平正对相机";
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake((self.bounds.size.width-160)/2.f, 20, 160, 40);
}


@end
