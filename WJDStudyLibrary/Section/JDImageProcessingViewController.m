//
//  JDImageProcessingViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDImageProcessingViewController.h"
#import "UIImage+JDImage.h"

@interface JDImageProcessingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JDImageProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)coverToGrayScale:(id)sender {
    
   _imageView.image = [_imageView.image covertToGrayScale];
}
- (IBAction)grayImage:(id)sender {
    
    _imageView.image = [_imageView.image grayImage];

}
- (IBAction)reset:(id)sender {
    
    _imageView.image =[UIImage imageNamed:@"i2.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
