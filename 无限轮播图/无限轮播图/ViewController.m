//
//  ViewController.m
//  无限轮播图
//
//  Created by czbk on 16/8/23.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"
#import "WSLCycleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *arrM = [[NSMutableArray alloc]init];
    for (int i = 1; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"business_ad_00%d",i]];
        
        [arrM addObject:image];
    }
    

    WSLCycleView *cycleView = [[WSLCycleView alloc]init];
    cycleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    
    cycleView.images = arrM.copy;
    
    [self.view addSubview:cycleView];
    
}



@end
