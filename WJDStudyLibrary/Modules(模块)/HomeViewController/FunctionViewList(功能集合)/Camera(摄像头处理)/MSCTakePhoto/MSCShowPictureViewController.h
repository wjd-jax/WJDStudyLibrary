//
//  MSCShowPictureViewController.h
//  MSCIDPhotoDemo
//
//  Created by miaoshichang on 2017/6/22.
//  Copyright © 2017年 miaoshichang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCShowPictureViewController : UIViewController

@property (nonatomic, strong)UIImage *image;

@property (nonatomic, copy)void(^block)(BOOL isFinished);

@end
