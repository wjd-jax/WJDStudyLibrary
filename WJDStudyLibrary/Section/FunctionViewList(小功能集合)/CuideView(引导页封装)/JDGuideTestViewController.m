//
//  JDGuideViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDGuideTestViewController.h"
#import "JDGuiewManager.h"

@interface JDGuideTestViewController ()

@property(nonatomic,retain)UIImageView *firstImageView;
@property(nonatomic,retain)UIButton *secondButton;
@property(nonatomic,retain)UILabel *thirdLabel;
@end

@implementation JDGuideTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [JDGuiewManager showGuideViewWithTapViews:@[_firstImageView,_secondButton,_thirdLabel] tip:@[@"点我😩",@"下一步😤",@"没有啦!🤒"]];

}
- (void)createUI {
    
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, SCREEN_HEIGHT/2)];
    [self.view addSubview:view];
    
    _firstImageView =[JDUtils createImageViewWithFrame:CGRectMake(300, 100, 40, 40) ImageName:@"apple"];
    [view addSubview:_firstImageView];
    
    _secondButton =[JDUtils createSystemButtonWithFrame:CGRectMake(100, 400, 150, 30) Target:self Action:@selector(buttonclick) Title:@"这是一个按钮"];
    [self.view addSubview:_secondButton];
    
    _thirdLabel =[JDUtils createLabelWithFrame:CGRectMake(20, 200, 200, 30) Font:16 Text:@"这是一段文字"];
    [_thirdLabel sizeToFit];
    [self.view addSubview:_thirdLabel];
    
}

-(void)buttonclick
{
    DLog(@"点击了按钮");
}



@end
