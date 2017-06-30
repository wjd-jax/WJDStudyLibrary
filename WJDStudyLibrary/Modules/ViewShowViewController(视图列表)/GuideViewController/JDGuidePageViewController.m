//
//  JDGuidePageViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDGuidePageViewController.h"

@interface JDGuidePageViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain) UIScrollView *pagingScrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,retain) UIButton *enterButton;
@property (nonatomic,strong) NSArray *backgroundViews;
@property (nonatomic,strong) NSArray *scrollViewPages;

@property (nonatomic,strong) NSArray *backgroundImageNames;
@property (nonatomic,strong) NSArray *coverImageNames;

@end

@implementation JDGuidePageViewController

- (void)dealloc
{
    _backgroundViews = nil;
    _coverImageNames = nil;
    _backgroundImageNames = nil;
    _scrollViewPages =nil;
    self.view = nil;

}
- (id)initWithCoverImageNames:(NSArray *)coverNames
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:nil];
    }
    return self;
}

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
    }
    return self;
}

- (id)initWithCoverImageNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames button:(UIButton *)button
{
    if (self = [super init]) {
        [self initSelfWithCoverNames:coverNames backgroundImageNames:bgNames];
        self.enterButton = button;
    }
    return self;
}

- (void)initSelfWithCoverNames:(NSArray *)coverNames backgroundImageNames:(NSArray *)bgNames
{
    self.coverImageNames = coverNames;
    self.backgroundImageNames = bgNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackgroundViews];
    [self addScrollViewPages];
    [self createScrollView];
    [self createPageControl];
    [self createEnterButton];
    [self reloadPages];
}

- (void)createEnterButton {
    
    if (!_enterButton) {
        _enterButton =[JDUtils createButtonWithFrame:[self frameOfEnterButton] ImageName:nil Target:self Action:@selector(enter:) Title:NSLocalizedString(@"Enter", @"进入应用")];
        JDViewSetRadius(_enterButton, 5);
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    JDViewBorderRadius(_enterButton, 0.5, [UIColor whiteColor].CGColor);
    _enterButton.alpha =0;
    [self.view addSubview:_enterButton];
}

- (void)createPageControl {
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:[self frameOfPageControl]];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.pageControl];
    
}

- (void)createScrollView
{
    self.pagingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.pagingScrollView.delegate = self;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.pagingScrollView];
    
}

- (void)addBackgroundViews
{
    _backgroundViews = [self getImageViewArrayWithImageNameArray:_backgroundImageNames];
    
    for (int i = 0; i<_backgroundViews.count; i++) {
        UIImageView *imageView =[_backgroundViews objectAtIndex:_backgroundViews.count-i-1];
        imageView.frame = self.view.bounds;
        [self.view addSubview:imageView];
    }
}
- (void)addScrollViewPages {
    
    self.scrollViewPages =[self getImageViewArrayWithImageNameArray:_coverImageNames];
    
}
- (NSArray *)getImageViewArrayWithImageNameArray:(NSArray *)names
{
    NSMutableArray *tmpArray = [NSMutableArray new];
    
    for (int i = 0; i<names.count; i++) {
        
        UIImageView *imageView =[JDUtils createImageViewWithFrame:self.view.bounds ImageName:[names objectAtIndex:i]];
        [tmpArray addObject:imageView];
    }
    
    return tmpArray;
}

- (void)reloadPages
{
    
    _pageControl.numberOfPages =_coverImageNames.count;
    self.pagingScrollView.contentSize =CGSizeMake(SCREEN_WIDHT*_scrollViewPages.count, SCREEN_HEIGHT);
    
    for (int i =0; i<_scrollViewPages.count; i++) {
        
        UIImageView *imageView = [_scrollViewPages objectAtIndex:i];
        imageView.frame =CGRectOffset(imageView.frame, i*SCREEN_WIDHT, 0);
        [_pagingScrollView addSubview:imageView];
    }
    
    if (self.pageControl.numberOfPages == 1) {
        self.enterButton.alpha = 1;
        self.pageControl.alpha = 0;
    }
    
}


- (CGRect)frameOfPageControl
{
    return CGRectMake(0, self.view.bounds.size.height - 30, self.view.bounds.size.width, 30);
}


- (CGRect)frameOfEnterButton
{
    CGSize size = self.enterButton.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(self.view.frame.size.width * 0.6, 35);
    }
    return CGRectMake(self.view.frame.size.width / 2 - size.width / 2, self.pageControl.frame.origin.y - size.height, size.width, size.height);
}
#pragma mark - 退出引导页事件
- (void)enter:(UIButton *)button
{
    CATransition *transition =[CATransition animation];
    transition.type =@"rippleEffect";
    transition.duration =0.8;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_didSelectedEnter) {
        
        _didSelectedEnter();
        
    }
}
#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index =scrollView.contentOffset.x/SCREEN_WIDHT;
    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * SCREEN_WIDHT) / SCREEN_WIDHT);
    if (_backgroundViews.count >index) {
        
        UIImageView *imageView =[_backgroundViews objectAtIndex:index];
        
        if (imageView) {
            imageView.alpha =alpha;
        }
    }
    self.pageControl.currentPage = index;
    
    [self pagingScrollViewDidChangePages:scrollView];
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (![self hasNext:self.pageControl]) {
        [self enter:nil];
    }
}
- (BOOL)hasNext:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages > pageControl.currentPage + 1;
}

- (BOOL)isLast:(UIPageControl*)pageControl
{
    return pageControl.numberOfPages == pageControl.currentPage + 1;
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView
{
    if ([self isLast:self.pageControl]) {
        if (self.pageControl.alpha == 1) {
            self.enterButton.alpha = 0;
            
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 1;
                self.pageControl.alpha = 0;
            }];
        }
    } else {
        if (self.pageControl.alpha == 0) {
            [UIView animateWithDuration:0.4 animations:^{
                self.enterButton.alpha = 0;
                self.pageControl.alpha = 1;
            }];
        }
    }
}


@end
