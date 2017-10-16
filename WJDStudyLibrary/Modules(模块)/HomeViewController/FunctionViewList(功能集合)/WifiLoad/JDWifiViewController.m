//
//  JDWifiViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/10/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDWifiViewController.h"
#import <HTTPServer.h>
#import "MyHTTPConnection.h"
#import "ZBTool.h"

@interface JDWifiViewController ()

@property(nonatomic,retain)HTTPServer *httpServer;
@property(nonatomic,retain)UILabel *httpLabel;
@end

@implementation JDWifiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    /*
     
     打开MyHTTPConnection.m，根据标记#pragma mark multipart form data parser delegate跳转或者直接找到139行，- (void) processStartOfPartWithHeader:(MultipartMessageHeader*) header方法，将其中filePath的值修改为iOS的某个目录，这个路径是上传的文件存储的路径
     
     */
    _httpLabel = [JDUtils createLabelWithFrame:CGRectMake(0, 0, SCREEN_WIDHT, 80) Font:28 Text:@""];
    _httpLabel.numberOfLines = 0;
    _httpLabel.center = self.view.center;
    _httpLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_httpLabel];
    
    _httpServer = [[HTTPServer alloc]init];
    [_httpServer setType:@"_htttp._tcp."];
    
    //资源路径
    NSString *webPath = [[NSBundle mainBundle] resourcePath];
    [_httpServer setDocumentRoot:webPath];
    [_httpServer setConnectionClass:[MyHTTPConnection class]];
    
    
    NSError *err;
    
    if ([_httpServer start:&err]) {
        
        _httpLabel.text  = [NSString stringWithFormat:@"请在PC浏览器中输入:\n%@:%hu",[ZBTool getIPAddress:YES],[_httpServer listeningPort]];
        
    }else{
        
        NSLog(@"%@",err);

    }
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_httpServer stop];
    
}


@end
