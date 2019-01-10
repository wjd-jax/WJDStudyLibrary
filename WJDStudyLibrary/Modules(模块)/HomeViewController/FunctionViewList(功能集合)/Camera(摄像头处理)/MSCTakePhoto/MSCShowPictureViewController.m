//
//  MSCShowPictureViewController.m
//  MSCIDPhotoDemo
//
//  Created by miaoshichang on 2017/6/22.
//  Copyright © 2017年 miaoshichang. All rights reserved.
//

#import "MSCShowPictureViewController.h"

@interface MSCShowPictureViewController ()

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation MSCShowPictureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //设置图层的frame
    CGFloat ScreenW = self.view.frame.size.width;
    CGFloat ScreenH = self.view.frame.size.height;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    headView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height-44-100)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
    
    // --- bottomView
    CGRect rect = CGRectMake(0, ScreenH-100, ScreenW, 100);
    UIView *bottomView = [[UIView alloc] initWithFrame:rect];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    // 重拍按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 60, 40)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"重拍" forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [bottomView addSubview:backButton];

    // 使用按钮
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomView.bounds.size.width-20-80, 30, 80, 40)];
    [applyBtn addTarget:self action:@selector(applyBackButton) forControlEvents:UIControlEventTouchUpInside];
    [applyBtn setTitle:@"使用照片" forState:UIControlStateNormal];
    [applyBtn setTintColor:[UIColor whiteColor]];
    [bottomView addSubview:applyBtn];
}


#pragma mark -返回按钮
- (void) clickBackButton
{
    if (self.block)
    {
        self.block(YES);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applyBackButton
{
    if (self.block)
    {
        self.block(YES);
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
