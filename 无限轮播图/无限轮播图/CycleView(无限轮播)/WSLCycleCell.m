//
//  WSLCycleCell.m
//  无限轮播图
//
//  Created by czbk on 16/8/23.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "WSLCycleCell.h"

@interface WSLCycleCell()

//显示图片
@property (weak, nonatomic) UIImageView *imageView;

@end


@implementation WSLCycleCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //布局
        [self setupUI];
    }
    return self;
}

//添加图片控件
- (void)setupUI{
    //创建imageView,大小等于contentView的大小
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    
    //全局
    self.imageView = imageView;
    
    //添加
    [self.contentView addSubview:imageView];
}

//图片赋值
- (void)setImage:(UIImage *)image{
    _image = image;
    self.imageView.image = image;
}

@end
