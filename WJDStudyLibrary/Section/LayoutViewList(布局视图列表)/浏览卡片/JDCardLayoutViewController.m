//
//  JDCardLayoutViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/2.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCardLayoutViewController.h"
#import "JDCardLayoutCollectionViewCell.h"

#define TAG 99

@interface JDCardLayoutViewController ()

@end

@implementation JDCardLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JDCardLayoutCollectionViewCell *cell = (JDCardLayoutCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(JDCardLayoutCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
//    UIView  *subview = [cell.contentView viewWithTag:TAG];
//    [subview removeFromSuperview];
    
    switch (indexPath.section) {
        case 0:
            cell.imageView.image =  [UIImage imageNamed:@"i1.jpg"];
//            cell.mainLabel.text = @"Glaciers";
            break;
        case 1:
            cell.imageView.image =  [UIImage imageNamed:@"i2.jpg"];
//            cell.mainLabel.text = @"Parrots";
            break;
        case 2:
            cell.imageView.image =  [UIImage imageNamed:@"i3.jpg"];
//            cell.mainLabel.text = @"Whales";
            break;
        case 3:
            cell.imageView.image =  [UIImage imageNamed:@"i4.jpg"];
//            cell.mainLabel.text = @"Lake View";
            break;
        case 4:
            cell.imageView.image =  [UIImage imageNamed:@"i5.jpg"];
            break;
        default:
            break;
    }
    
}


@end
