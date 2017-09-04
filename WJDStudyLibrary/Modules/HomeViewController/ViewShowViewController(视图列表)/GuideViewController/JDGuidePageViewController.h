//
//  JDGuidePageViewController.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDBaseViewController.h"

typedef void (^DidSelectedEnter)(void);

@interface JDGuidePageViewController : JDBaseViewController

@property(nonatomic,copy)DidSelectedEnter didSelectedEnter;


- (id)initWithCoverImageNames:(NSArray*)coverNames;

- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames;

- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames button:(UIButton*)button;

@end
