//
//  JDPrintLabelViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDPrintLabelViewController.h"
#import "JDPrintLabel.h"

@interface JDPrintLabelViewController ()

@property (nonatomic,retain)JDPrintLabel *pLabel;
@end

@implementation JDPrintLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    _pLabel =[[JDPrintLabel alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHT, 450)];
    _pLabel.text =@"\n永和九年，岁在癸丑，暮春之初，会于会稽山阴之兰亭，修禊事也。\n群贤毕至，少长咸集。此地有崇山峻岭，茂林修竹，又有清流激湍，映带左右，引以为流觞曲水，列坐其次。\n虽无丝竹管弦之盛，一觞一咏，亦足以畅叙幽情。！";
    _pLabel.numberOfLines =0;
    _pLabel.backgroundColor =[UIColor clearColor];
    _pLabel.prientColor =[UIColor greenColor];
    [_pLabel sizeToFit];
    _pLabel.completeBlock = ^{
        
        [JDMessageView showMessage:@"打印完成"];
    };
    [self.view addSubview:_pLabel];
    [_pLabel startPrint];
}


 

@end
