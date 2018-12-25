//
//  UIView+JDView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "UIView+JDView.h"

@implementation UIView (JDView)

#pragma mark - Getter

-(CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


-(CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

-(CGFloat)boardWidth{
    return self.layer.borderWidth;
}

-(UIColor *)boardColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (CGFloat)originX{
    
    return CGRectGetMinX(self.frame);
}

- (CGFloat)originY{
    
    return CGRectGetMinY(self.frame);
}

- (CGPoint)origin{
    
    return self.frame.origin;
}

- (CGFloat)sizeWidth{
    
    return CGRectGetWidth(self.frame);
}

- (CGFloat)sizeHeight{
    
    return CGRectGetHeight(self.frame);
}

- (CGSize)size{
    
    return self.frame.size;
}

- (CGFloat)centerX{
    
    return self.center.x;
}

- (CGFloat)centerY{
    
    return self.center.y;
}

#pragma mark - Setter

- (void)setOriginX:(CGFloat)x{
    
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setOriginY:(CGFloat)y{
    
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setOrigin:(CGPoint)origin{
    
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (void)setSizeWidth:(CGFloat)width{
    
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setSizeHeight:(CGFloat)height{
    
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setSize:(CGSize)size{
    
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setCenterX:(CGFloat)x{
    
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void)setCenterY:(CGFloat)y{
    
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

-(void)setBoardColor:(UIColor *)boardColor
{
    self.layer.borderColor = boardColor.CGColor;
}
-(void)setBoardWidth:(CGFloat)boardWidth
{
    self.layer.borderWidth = boardWidth;
}
@end
