//
//  WSLCycleFlowLayout.m
//  无限轮播图
//
//  Created by czbk on 16/8/23.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "WSLCycleFlowLayout.h"

@implementation WSLCycleFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    //大小
    self.itemSize = self.collectionView.bounds.size;
    
    //滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //间距
    self.minimumLineSpacing = 0;
}

@end
