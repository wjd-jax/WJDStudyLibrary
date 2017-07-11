//
//  JDBankScanViewController.m
//  
//
//  Created by wangjundong on 2017/7/11.
//
//

#import "JDBankScanViewController.h"
#import "OverlayView.h"

@interface JDBankScanViewController ()

@property (nonatomic, strong) OverlayView *overlayView;


@end

@implementation JDBankScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银行卡扫描";
    [self.view insertSubview:self.overlayView atIndex:0];

    // Do any additional setup after loading the view.
}


- (OverlayView *)overlayView {
    if(!_overlayView) {
        CGRect rect = [OverlayView getOverlayFrame:[UIScreen mainScreen].bounds];
        _overlayView = [[OverlayView alloc] initWithFrame:rect];
    }
    return _overlayView;
}

@end
