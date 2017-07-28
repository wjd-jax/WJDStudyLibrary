//
//  JDActionSheetView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/4.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDActionSheetView.h"

@interface JDActionSheetView ()

/** block回调 */
@property (copy, nonatomic) JDActionSheetBlock actionSheetBlock;
/** 背景图片 */
@property (strong, nonatomic) UIView *backgroundView;
/** 弹出视图 */
@property (strong, nonatomic) UIView *actionSheetView;

@end

@implementation JDActionSheetView

static const CGFloat kRowHeight = 48.0f;
static const CGFloat kRowLineHeight = 0.5f;
static const CGFloat kSeparatorHeight = 6.0f;
static const CGFloat kTitleFontSize = 13.0f;
static const CGFloat kButtonTitleFontSize = 18.0f;
static const NSTimeInterval kAnimateDuration = 0.3f;

//调用方法
+ (void)showActionSheetWithTitle:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSArray *)otherButtonTitles
                         handler:(JDActionSheetBlock)actionSheetBlock{
    
    JDActionSheetView *actionSheetView =[self actionSheetWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:actionSheetBlock];
    [actionSheetView show];
    
}

//类方法初始化
+ (instancetype)actionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(JDActionSheetBlock)actionSheetBlock
{
    return [[self alloc] initWithTitle:title cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles handler:actionSheetBlock];
}

//实例化方法
- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(JDActionSheetBlock)actionSheetBlock{
    
    self =[ super initWithFrame:CGRectZero];
    if (self) {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        _actionSheetBlock = actionSheetBlock;
        
        CGFloat actionSheetHeight = 0;
        //背景视图
        _backgroundView =[[UIView alloc]initWithFrame:self.frame];
        _backgroundView.backgroundColor =[UIColor colorWithWhite:0 alpha:0.4];
        //列表视图
        _actionSheetView =[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        _actionSheetView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        
        [self addSubview:_backgroundView];
        [self addSubview:_actionSheetView];
        
        UIImage *normalImage = [self imageWithColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        UIImage *highlightedImage = [self imageWithColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        //标题
        if (title && title.length >0) {
            actionSheetHeight += kRowLineHeight;
            CGFloat titleHeight =ceil([title boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTitleFontSize]} context:nil].size.height) + 15*2;
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, actionSheetHeight, self.frame.size.width, titleHeight)];
            
            titleLabel.text = title;
            titleLabel.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            titleLabel.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
            titleLabel.numberOfLines = 0;
            [_actionSheetView addSubview:titleLabel];
            
            actionSheetHeight += titleHeight;
            
        }
        //销毁按钮
        if (destructiveButtonTitle && destructiveButtonTitle.length > 0)
        {
            actionSheetHeight += kRowLineHeight;
            
            UIButton *destructiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            destructiveButton.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
            destructiveButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            destructiveButton.tag = -1;
            destructiveButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
            [destructiveButton setTitleColor:[UIColor colorWithRed:230.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [destructiveButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [destructiveButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:destructiveButton];
            
            actionSheetHeight += kRowHeight;
        }
        //选项按钮
        if (otherButtonTitles && [otherButtonTitles count] > 0)
        {
            for (int i = 0; i < otherButtonTitles.count; i++)
            {
                actionSheetHeight += kRowLineHeight;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
                button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                button.tag = i+1;
                button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
                [button setTitle:otherButtonTitles[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                [button setBackgroundImage:normalImage forState:UIControlStateNormal];
                [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_actionSheetView addSubview:button];
                
                actionSheetHeight += kRowHeight;
            }
        }
        //取消按钮
        if (cancelButtonTitle && cancelButtonTitle.length > 0)
        {
            actionSheetHeight += kSeparatorHeight;
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
            cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cancelButton.tag = 0;
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [cancelButton setTitle:cancelButtonTitle ?: @"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:cancelButton];
            
            actionSheetHeight += kRowHeight;
        }
        
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, actionSheetHeight);
        
    }
    return self;
    
}
#pragma mark - 显示跟消失
- (void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundView.alpha = 0;

    [UIView animateWithDuration:kAnimateDuration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 1.0f;
        self.actionSheetView.frame = CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
    } completion:nil];
    
}

- (void)dismiss{
    
    [UIView animateWithDuration:kAnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.alpha = 0;
        self.actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}
//点击背景取消
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.backgroundView];
    if (!CGRectContainsPoint(self.actionSheetView.frame, point))
    {
        if (self.actionSheetBlock)
        {
            self.actionSheetBlock(self, 0);
        }
        
        [self dismiss];
    }
}
#pragma mark - 按钮点击
- (void)buttonClicked:(UIButton *)button
{
    if (self.actionSheetBlock)
    {
        self.actionSheetBlock(self, button.tag);
    }
    
    [self dismiss];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
