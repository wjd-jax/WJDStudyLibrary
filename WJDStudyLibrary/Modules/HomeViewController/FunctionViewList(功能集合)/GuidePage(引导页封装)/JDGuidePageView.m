//
//  JDGuidePageView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/6/29.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDGuidePageView.h"


#define kScreen_height  [[UIScreen mainScreen] bounds].size.height
#define kScreen_width   [[UIScreen mainScreen] bounds].size.width

@interface JDGuidePageView ()<UIScrollViewDelegate>

@property(nonatomic,retain)UIScrollView  *launchScrollView;
@property(nonatomic,retain)UIPageControl *page;
@property(nonatomic,retain)UIButton *enterButton;

@property(nonatomic,retain)NSArray *images;

@end


@implementation JDGuidePageView


- (instancetype)initGuideViewWithImages:(NSArray *)imageNames{
    
    self =[[JDGuidePageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    _isScrollOut = YES;
    self.images = imageNames;
    return self;
    
}

- (instancetype)initGuideViewWithImages:(NSArray *)imageNames button:(UIButton *)button{
    
    self =[[JDGuidePageView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    _isScrollOut = YES;
    //一定要先赋值button因为后边要用到
    self.enterButton = button;
    self.images = imageNames;
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor =[UIColor whiteColor];
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    _launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    _launchScrollView.showsHorizontalScrollIndicator = NO;
    _launchScrollView.bounces = NO;
    _launchScrollView.pagingEnabled = YES;
    _launchScrollView.delegate = self;
    [self addSubview:_launchScrollView];
    
}


-(void)setImages:(NSArray *)images
{
    _images = images;
    
    _launchScrollView.contentSize = CGSizeMake(kScreen_width * images.count, kScreen_height);
    for (int i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreen_width, 0, kScreen_width, kScreen_height)];
        imageView.image = [UIImage imageNamed:images[i]];
        [_launchScrollView addSubview:imageView];
        
        if (i == images.count - 1) {
            
            _enterButton = [self getEnterButton];
            [imageView addSubview:_enterButton];
            imageView.userInteractionEnabled = YES;
        }
    }
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreen_height - 50, kScreen_width, 30)];
    _page.numberOfPages = images.count;
    _page.backgroundColor = [UIColor clearColor];
    _page.currentPage = 0;
    _page.defersCurrentPageDisplay = YES;
    [self addSubview:_page];
    
}
-(void)setIsShowPageView:(BOOL)isShowPageView
{
    _page.hidden = !isShowPageView;
}

- (UIButton *)getEnterButton
{
    if (!_enterButton) {
        
        _enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _enterButton.backgroundColor = JDCOLOR_FROM_RGB_OxFF_ALPHA(0x40eb78, 1);
        _enterButton.layer.cornerRadius = 5;
        [_enterButton setTitle:@"点击进入" forState:UIControlStateNormal];
    }
    _enterButton.center = CGPointMake(kScreen_width/2, kScreen_height-80);
    [_enterButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return _enterButton;
}

-(void)setEnterButton:(UIButton *)enterButton
{
    _enterButton = enterButton;
}

-(void)setCurrentColor:(UIColor *)currentColor
{
    _page.currentPageIndicatorTintColor = currentColor;
}

-(void)setNomalColor:(UIColor *)nomalColor
{
    _page.pageIndicatorTintColor = nomalColor;

}

#pragma mark - scrollView Delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
    //如果是最后一页左滑
    if (cuttentIndex == self.images.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (_isScrollOut) {
                [self hideGuideView];
            }
        }
    }
}

//修改page的显示
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _launchScrollView) {
        
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
        _page.currentPage = cuttentIndex;
    }
}

#pragma mark - 判断滚动方向
-(BOOL )isScrolltoLeft:(UIScrollView *) scrollView{
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}



- (void)enterBtnClick{
    
    [self hideGuideView];
}

- (void)hideGuideView {
    //动画隐藏
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        //延迟0.5秒移除
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }];
}

-(void)dealloc
{
    
}

@end
