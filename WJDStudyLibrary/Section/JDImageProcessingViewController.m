//
//  JDImageProcessingViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDImageProcessingViewController.h"
#import "UIImage+JDImage.h"

@interface JDImageProcessingViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,retain)NSArray *filterNameArray;
@end

@implementation JDImageProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _filterNameArray = [CIFilter filterNamesInCategory:@"CICategoryBuiltIn"];
//    DLog(@"总共有%ld种滤镜效果:%@",_filterNameArray.count,filterNames);
   // NSString *allFilter =@"CIPhotoEffectChrome,CIPhotoEffectFade,CIPhotoEffectInstant,CIPhotoEffectMono,CIPhotoEffectNoir,CIPhotoEffectProcess,CIPhotoEffectTonalCIPhotoEffectTransfer";
   // _filterNameArray =[allFilter componentsSeparatedByString:@","];
    
    // Do any additional setup after loading the view.
}
- (IBAction)coverToGrayScale:(id)sender {
    
    _imageView.image = [_imageView.image covertToGrayScale];
}
- (IBAction)gaosiBlur:(id)sender {
    
    _imageView.image = [_imageView.image gaussianBlur];
}
- (IBAction)grayImage:(id)sender {
    
    _imageView.image = [_imageView.image grayImage];
    
}
- (IBAction)reset:(id)sender {
    
    _imageView.image =[UIImage imageNamed:@"i2.jpg"];
}

- (IBAction)filterClick:(id)sender {
    _pickerView.hidden =!_pickerView.hidden;
}
#pragma mark - UIPickerViewDataSource

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _filterNameArray.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_filterNameArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _imageView.image =[UIImage imageNamed:@"i2.jpg"];

    _imageView.image = [_imageView.image setFilterWithFilterName:[_filterNameArray objectAtIndex:row]];
 
}

/*
 NSArray* filters =  [CIFilter filterNamesInCategory:kCICategoryDistortionEffect];
 for (NSString* filterName in filters) {
 NSLog(@"filter name:%@",filterName);
 // 我们可以通过filterName创建对应的滤镜对象
 CIFilter* filter = [CIFilter filterWithName:filterName];
 NSDictionary* attributes = [filter attributes];
 // 获取属性键/值对（在这个字典中我们可以看到滤镜的属性以及对应的key）
 NSLog(@"filter attributes:%@",attributes);
 }
 */

@end
