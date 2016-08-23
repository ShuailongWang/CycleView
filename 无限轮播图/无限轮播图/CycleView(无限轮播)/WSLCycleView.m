//
//  WSLCycleView.m
//  无限轮播图
//
//  Created by czbk on 16/8/23.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "WSLCycleView.h"
#import "WSLCycleCell.h"
#import "WSLCycleFlowLayout.h"
#import "Masonry.h"

#define kSeed 10
static NSString *cellID = @"cellID";

@interface WSLCycleView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) UIPageControl *pageControl;         //页码
@property (weak, nonatomic) UICollectionView *collectionView;   //collectionView
@property (strong, nonatomic) NSTimer *timer;                   //定时器


@end

@implementation WSLCycleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //
        [self setupUI];
    }
    return self;
}


- (void)setupUI{
    //MARK: -collectionView
    //    self.backgroundColor = [UIColor redColor];
    //layout
    WSLCycleFlowLayout *layout = [[WSLCycleFlowLayout alloc]init];
    
    //collectionView
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    
    //添加
    [self addSubview:collectionView];
    
    //设置collectionView
    collectionView.pagingEnabled = YES;                 //翻页
    collectionView.showsHorizontalScrollIndicator = NO; //滚动条
    
    //设置代理
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    //注册cell
    [collectionView registerClass:[WSLCycleCell class] forCellWithReuseIdentifier:cellID];
    
    //全局
    self.collectionView = collectionView;
    
    //约束
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    
    //页码
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    
    //选中颜色与默认颜色
    pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.2 alpha:1];
    
    //添加,全局
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    //约束
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(15);
    }];
    
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(playPicture) userInfo:nil repeats:YES];
    
    //定时器
    if (self.timer == nil) {
        //创建定时器,2秒  ,执行playPicture方法
        NSTimer *timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(playPicture) userInfo:nil repeats:YES];
        
        //开启线程
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        //全局
        self.timer = timer;
    }
}

//图片滚动
- (void)playPicture{
    //刷新collectionView
    [self.collectionView reloadData];
    
    //重新布局子控件
    [self layoutIfNeeded];
    
    //偏移量
    CGFloat offsetX = self.collectionView.contentOffset.x;
    
    //
    [self.collectionView setContentOffset:CGPointMake(offsetX + self.collectionView.bounds.size.width, 0) animated:YES];
}

//设置图片
- (void)setImages:(NSArray<UIImage*> *)images{
    //图片赋值
    _images = images;
    
    //重新布局子控件
    [self layoutIfNeeded];
    
    //创建indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_images.count *kSeed / 2 inSection:0];
    
    //collection滚动到哪里,从哪个方向
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition: UICollectionViewScrollPositionLeft animated:NO];
    
    //多少页码
    self.pageControl.numberOfPages = _images.count;
}

#pragma mark -CollectionView的数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _images.count * kSeed;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //创建cell
    WSLCycleCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    //
    cell.image = _images[indexPath.item % _images.count];
    
    return cell;
}

#pragma mark -CollectionView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    //第几页
    CGFloat page = offsetX / scrollView.bounds.size.width;
    
    //当前的页
    self.pageControl.currentPage = (NSInteger)(page + 0.5) % _images.count;
}

//拖拽
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    NSLog(@"xxx");
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    //页面显示的cell
    UICollectionViewCell *lastCell = collectionView.visibleCells.lastObject;
    
    NSIndexPath *indexPath = [collectionView indexPathForCell:lastCell];
    
    if (indexPath.item == [collectionView numberOfItemsInSection:0]- 1) {
        collectionView.contentOffset = CGPointMake((_images.count *kSeed/2 - 1)*collectionView.frame.size.width, 0);
    }
    
    //
    if (indexPath.item == 0){
        collectionView.contentOffset = CGPointMake(_images.count *kSeed/2*collectionView.frame.size.width, 0);
    }
}

//将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //销毁定时器
    self.timer.fireDate = [NSDate distantFuture];
}

//拖拽结束,
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //开启定时器
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_images.count *kSeed/2 inSection:0];
    //    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition: UICollectionViewScrollPositionLeft animated:NO];
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self.timer invalidate];
}


@end
