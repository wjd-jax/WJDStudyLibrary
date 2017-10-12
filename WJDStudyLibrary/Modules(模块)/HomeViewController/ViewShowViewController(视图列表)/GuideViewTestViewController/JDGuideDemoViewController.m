//
//  JDGuideDemoViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/30.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDGuideDemoViewController.h"
#import "JDGuidePageView.h"

@interface JDGuideDemoViewController ()

@end

@implementation JDGuideDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self addGuideView];
}

- (void)addGuideView {
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    JDGuidePageView *guideView =[[JDGuidePageView alloc]initGuideViewWithImages:@[@"guide_01", @"guide_02", @"guide_03",@"guide_04"] ];
    guideView.isShowPageView = YES;
    guideView.isScrollOut = NO;
    guideView.currentColor =[UIColor redColor];
    [window addSubview:guideView];

}

- (void)createUI {
    
    UIImageView *imageView =[JDUtils createImageViewWithFrame:self.view.bounds ImageName:@"home_bgImage"];
    [self.view addSubview:imageView];
    
    UILabel *label =[JDUtils createLabelWithFrame:CGRectMake(130, 100, 200, 30) Font:24 Text:@"哇!首页出来了"];
    [imageView addSubview:label];
    
    UIButton *button =[JDUtils createButtonWithFrame:CGRectMake(SCREEN_WIDHT-100, SCREEN_HEIGHT-50, 80, 30) ImageName:nil Target:self Action:@selector(onceMore) Title:@"再看一遍!"];
    [imageView addSubview:button];
    imageView.userInteractionEnabled =YES;
    
}

- (void)onceMore {
    
    [self addGuideView];

}


@end
