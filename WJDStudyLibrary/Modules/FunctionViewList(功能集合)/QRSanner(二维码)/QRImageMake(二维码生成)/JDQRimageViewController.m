//
//  JDQRimageViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/14.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDQRimageViewController.h"
#import "JDQRCodeWapper.h"

@interface JDQRimageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *barLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;

@end

@implementation JDQRimageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)buttonClick:(id)sender {
    
    _QRImageView.image =[JDQRCodeWapper generateQRCode:_inputTextView.text width:_QRImageView.sizeWidth height:_QRImageView.sizeHeight];
   
    _barLabel.text =@"";
}

- (IBAction)barCodeButtonClick:(id)sender {
    
    _inputTextView.text =@"abcd12343535123";
    _barLabel.text =_inputTextView.text;
    _QRImageView.image =[JDQRCodeWapper generateBarCode:_inputTextView.text width:_QRImageView.sizeWidth height:_QRImageView.sizeHeight];
}


@end
