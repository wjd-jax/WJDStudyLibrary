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
@end
