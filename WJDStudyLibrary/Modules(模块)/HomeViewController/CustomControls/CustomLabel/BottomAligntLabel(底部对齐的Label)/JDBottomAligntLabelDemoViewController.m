//
//  JDBottomAligntLabelDemoViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDBottomAligntLabelDemoViewController.h"
#import "JDBottomAlignmentLabel.h"

@interface JDBottomAligntLabelDemoViewController ()

@end

@implementation JDBottomAligntLabelDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JDBottomAlignmentLabel *view = [[JDBottomAlignmentLabel alloc]initWithFrame:CGRectMake(20, 100, SCREEN_WIDHT-40, 40)];
    
    [self.view addSubview:view];
    [view addText:@"这是" Font:[UIFont systemFontOfSize:12] TextColor:[UIColor blueColor] IsChinese:YES];
    [view addText:@"一段" Font:[UIFont systemFontOfSize:18] TextColor:[UIColor blackColor] IsChinese:YES];
    [view addText:@"大小" Font:[UIFont systemFontOfSize:14] TextColor:[UIColor greenColor] IsChinese:YES];
    [view addText:@"不同" Font:[UIFont systemFontOfSize:32] TextColor:[UIColor blackColor] IsChinese:YES];
    [view addText:@"的" Font:[UIFont systemFontOfSize:10] TextColor:[UIColor greenColor] IsChinese:YES];
    [view addText:@"文字" Font: [UIFont systemFontOfSize:18] TextColor:[UIColor redColor] IsChinese:YES];

}



@end
