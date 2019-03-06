//
//  MSCTakeFacePictureView.m
//  MSCIDPhotoDemo
//
//  Created by miaoshichang on 2017/6/22.
//  Copyright © 2017年 miaoshichang. All rights reserved.
//

#import "MSCTakeFacePictureView.h"

@interface MSCTakeFacePictureView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation MSCTakeFacePictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self makeupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [self makeupUI];
    }

    return self;
}

- (void)makeupUI {
    //
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithRed:0xff / 255.f green:0xbc / 255.f blue:0x2e / 255.f alpha:1];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"拍摄正面身份证";
    [self addSubview:self.titleLabel];

    //
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.text = @"将身份证放入虚线框内，亮度均匀";
    [self addSubview:self.detailLabel];

    self.headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_kaluli_zhengmian"]];
    [self addSubview:self.headImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.frame = CGRectMake(0, 10, self.bounds.size.width, 28);
    self.detailLabel.frame = CGRectMake(0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.bounds.size.width, 22);

    float kWidth = 240;
    float kHeight = 360;
    float kScreenWidth = self.bounds.size.width;
    //    float kScreenHeight = self.bounds.size.height;
    // 375
    float scale = kScreenWidth / 375.f;

    CGRect cropRect = CGRectMake((self.size.width-kWidth*scale)/2,(self.size.height-kHeight*scale)/2, kWidth * scale, kHeight * scale);
    [self setCropRect:cropRect];

    self.headImageView.frame = CGRectMake(cropRect.origin.x + 50 * scale, cropRect.origin.y + 212 * scale, 140 * scale, 112 * scale);
}

- (void)setCropRect:(CGRect)cropRect {
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    }

    self.shapeLayer = [[CAShapeLayer alloc] init];
    [self.shapeLayer setStrokeColor:[UIColor blackColor].CGColor];
    [self.shapeLayer setLineWidth:1];
    [self.shapeLayer setLineJoin:kCALineJoinRound];
    [self.shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3], [NSNumber numberWithInt:3], nil]];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRoundedRect(path, nil, cropRect, 3.f, 3.f);
    CGPathAddRect(path, nil, self.bounds);

    [self.shapeLayer setFillRule:kCAFillRuleEvenOdd];
    [self.shapeLayer setPath:path];
    [self.shapeLayer setFillColor:[UIColor blackColor].CGColor];
    [self.shapeLayer setOpacity:0.6];
    [self.shapeLayer setNeedsDisplay];
    [self.layer insertSublayer:self.shapeLayer atIndex:0];
}


@end
