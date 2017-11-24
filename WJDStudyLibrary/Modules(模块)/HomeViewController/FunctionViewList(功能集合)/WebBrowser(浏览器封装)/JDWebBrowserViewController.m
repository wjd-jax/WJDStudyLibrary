//
//  JDWebBrowserViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/4.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDWebBrowserViewController.h"
#import <WebKit/WebKit.h>

static NSString *homeURL =@"https://www.jianshu.com";//@"http://naotu.baidu.com";
//static int barHeight =49;
@interface JDWebBrowserViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>

@property(nonatomic,retain) UIProgressView *progressView;
@property(nonatomic,retain) WKWebView *webView;
@property(nonatomic,retain) UIToolbar *toolBar;
@property(nonatomic,copy) NSString *urlString;
@property(nonatomic,retain) UITextField *navTextfield;
@property(nonatomic,assign) BOOL debug;

@end
/*
 说明
 >白屏时间，白屏时间无论安卓还是iOS在加载网页的时候都会存在的问题，也是目前无法解决的；
 >页面耗时，页面耗时指的是开始加载这个网页到整个页面load完成即渲染完成的时间；
 >加载链接的一些性能数据，重定向时间，DNS解析时间，TCP链接时间，request请求时间，response响应时间，dom节点解析时间，page渲染时间，同时我们还需要抓取资源时序数据，
 
 */
@implementation JDWebBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;
    [self createWebView];
    [self addToolBarItem];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.toolbarHidden = YES;
    
}
#pragma mark - UI
- (void)createWebView {
    
    WKWebViewConfiguration *config =[self getWkWebViewConfiguration];
    _webView =[[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    //    _webView.sizeHeight =_webView.sizeHeight-49;
    
    _webView.navigationDelegate = self;
    //_webView.UIDelegate =self;
    _webView.scrollView.delegate =self;
    _webView.allowsBackForwardNavigationGestures = YES;    // 允许左右划手势导航，默认NO
    //监听进度
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlString?_urlString:homeURL]];
    [request setTimeoutInterval:10];
    _urlString =homeURL;
    [_webView loadRequest:request];
    // [webView.configuration.userContentController addScriptMessageHandler:self name:@"Share"];
    
    [self.view addSubview:_webView];
    [self.view addSubview:[self progressView]];
    [self.view bringSubviewToFront:_toolBar];
}


-(void)addToolBarItem
{
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc]initWithTitle:@"前进" style:UIBarButtonItemStylePlain target:self action:@selector(goTo)];
    UIBarButtonItem *itemA = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    UIBarButtonItem *itemB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refesh)];
    UIBarButtonItem *itemC = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item4 = [[UIBarButtonItem alloc]initWithTitle:@"safari" style:UIBarButtonItemStylePlain target:self action:@selector(openSafari)];
    
    
    self.toolbarItems =@[item0,itemA,item1,itemB,item3,itemC,item4];
}

- (void)goTo {
    WKNavigation *navigation = [_webView goForward];
    if (!navigation)[JDMessageView showMessage:@"没有了"];
}
- (void)goBack {
    
    WKNavigation *navigation =  [_webView goBack];
    if (!navigation)[JDMessageView showMessage:@"没有了"];
    
}
- (void)refesh {
    
    [_webView reload];
}
- (void)openSafari {
    [[UIApplication sharedApplication] openURL:_webView.URL];
}
- (void)refeshClick {
    [_webView reload];
}
#pragma mark - Action

#pragma mark -自定义API
+ (void)openUrl:(NSString *)urlString fromViewController:(UIViewController *)viewController
{
    JDWebBrowserViewController *vc =[[JDWebBrowserViewController alloc]init];
    vc.urlString =urlString;
    
    if (viewController.navigationController) {
        [viewController.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [viewController presentViewController:viewController animated:YES completion:nil];
    }
}

#pragma mark - 配置WKWebViewConfiguration
- (WKWebViewConfiguration *)getWkWebViewConfiguration
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 10;//最小的字体大小,默认是0
    config.preferences.javaScriptEnabled = YES; //是否支持JavaScript
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;//不通过用户交互，是否可以打开窗口
    
    return config;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView =[[UIProgressView alloc]initWithFrame:CGRectMake(0, Navigation_HEIGHT, SCREEN_WIDHT, 12)];
        _progressView.tintColor =[UIColor greenColor];
        _progressView.trackTintColor =[UIColor whiteColor];
    }
    return _progressView;
}
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}
#pragma mark - WKNavigationDelegate 页面加载过程
//开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    if (_debug) DLog(@"开始加载%@",[NSDate date].description);
    self.title =@"加载中...";
    DLog(@"%@",    _webView.backForwardList);
}
//当内容开始返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    if (_debug) DLog(@"开始返回%@",[NSDate date].description);
    
}
//页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (_debug) DLog(@"加载完成%@",[NSDate date].description);
    self.title =webView.title;
    
    
}
// 页面加载失败时调用(经过测试,不会执行)

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    if (error) {
        
        /*
         error.userInfo
         
         NSErrorFailingURLKey = "https://www.jianshu.com/";
         NSErrorFailingURLStringKey = "https://www.jianshu.com/";
         NSLocalizedDescription = "The Internet connection appears to be offline.";
         NSUnderlyingError = "Error Domain=kCFErrorDomainCFNetwork Code=-1009 \"(null)\" UserInfo={_kCFStreamErrorCodeKey=50, _kCFStreamErrorDomainKey=1}";
         "_WKRecoveryAttempterErrorKey" = "<WKReloadFrameErrorRecoveryAttempter: 0x170225d40>";
         "_kCFStreamErrorCodeKey" = 50;
         "_kCFStreamErrorDomainKey" = 1;
         */
        
        DLog(@"%@",error.userInfo);
        if (error.userInfo[@"_kCFStreamErrorCodeKey"]) {
            if ([error.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] ==50) {
                self.title =@"无网络";
            }
            else if ([error.userInfo[@"_kCFStreamErrorCodeKey"] integerValue] ==-2102) {
                self.title =@"超时";
            }
        }
        else
        {
            self.title =webView.title;
            
            NSURL *url2 =error.userInfo[@"NSErrorFailingURLKey"]; //注意这里返回的是个 NSURL 类型的 千万别以为是 NSString 的
            
            if (url2) [[UIApplication sharedApplication] openURL:url2];
            else      [JDMessageView showMessage:@"无法跳转"];
            
        }
        
        /*
         NSString *url = error.userInfo[@"NSErrorFailingURLKey"];
         
         //Note: 在iOS9中,如果你要想使用canOpenURL, 你必须添加URL schemes到Info.plist中的白名单, 否则一样跳转不了...
         BOOL didOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
         if (didOpen) {
         DLog(@"打开成功");
         }
         else
         {
         
         }
         */
    }
    else{
        self.title =@"加载失败!";
    }
}
//navigation发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation
      withError:(NSError *)error
{
    
}

//web视图需要响应身份验证时调用。
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [webView reload];
}


#pragma mark - 用户交互
//是否允许加载网页 在发送请求之前,决定是否跳转(点击跳转的时候,会执行两遍)
/*
 接下里就是交互部分了
 这里主要用到的是用户点击web页面的按钮，App拦截下来，在App端进行处理
 当用户点击页面的按钮，会走
 */

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlString =[[navigationAction.request URL] absoluteString];
    //注意对于url中的中文是无法解析的，需要进行url编码(指定编码类型为utf-8)
    //另外注意url解码使用stringByRemovingPercentEncoding方法
    urlString =[urlString stringByRemovingPercentEncoding];
    DLog(@"urlString=%@",urlString);
    // 用://截取字符串
    NSArray *urlComps =[urlString componentsSeparatedByString:@"://"];
    if ([urlComps count]) {
        //获取协议头
        NSString *protocolHead =[urlComps objectAtIndex:0];
        DLog(@"协议头=%@",protocolHead);
    }
    decisionHandler(WKNavigationActionPolicyAllow);//拦截执行
}

// 在收到响应后，决定是否跳转
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //不加回调会 cash
    decisionHandler(WKNavigationResponsePolicyAllow);
    
    /*
     <WKNavigationResponse: 0x100a57010; response = <NSHTTPURLResponse: 0x17003af00> { URL: https://www.baidu.com/ } { status code: 200, headers {
     "Cache-Control" = "no-cache";
     Connection = "keep-alive";
     "Content-Encoding" = gzip;
     "Content-Length" = 73241;
     "Content-Type" = "text/html;charset=utf-8";
     Date = "Fri, 05 May 2017 01:24:04 GMT";
     P3p = "CP=\" OTI DSP COR IVA OUR IND COM \"";
     Server = "bfe/1.0.8.18";
     "Set-Cookie" = "BAIDUID=1005037D8CF719C18634AF26D533377C:FG=1; max-age=31536000; expires=Sat, 05-May-18 01:24:03 GMT; domain=.baidu.com; path=/; version=1, H_WISE_SIDS=110315_108270_100186_114824_115880_102629_108372_107311_115339_115576_115704_115702_115497_114798_115933_115554_115534_115624_115446_114329_115359_115350_114276_115863_110085; path=/; domain=.baidu.com, BDSVRTM=347; path=/, __bsi=14516488606701504009_00_45_N_N_349_0303_C02F_N_N_Y_0; expires=Fri, 05-May-17 01:24:09 GMT; domain=www.baidu.com; path=/";
     "Strict-Transport-Security" = "max-age=172800";
     Traceid = 1493947444061794561010399075394808135205;
     } }>
     
     */
    
}
// 接收到服务器跳转请求之后调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

#pragma mark - WKScriptMessageHandler：必须实现的函数，是APP与js交互，提供从网页中收消息的回调方法
// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}

#pragma mark - WKUIDelegate UI界面相关，原生控件支持，三种提示框：输入、确认、警告。首先将web提示框拦截然后再做处理。

//与JS的alert、confirm、prompt交互，我们希望用自己的原生界面，而不是JS的，就可以使用这个代理类来实现。

// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    return nil;
}
/// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
        textField.placeholder =defaultText;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}
/// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"confirm message:%@", message);
    
}
/// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
