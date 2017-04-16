//
//  ViewController.m
//  CircleProgressView
//
//  Created by 陈舟为 on 2017/3/21.
//  Copyright © 2017年 DaveChen. All rights reserved.
//

#import "ViewController.h"

#import "CircleProgressView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    CircleProgressView *view = [CircleProgressView circleViewShowInView:self.view];
    
    view.progress = 0.5;
    
    [self.view addSubview:view];
    
    
//    带动画效果的进度视图
    CircleProgressViewWithAnimation *animationView = [[CircleProgressViewWithAnimation alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    
    animationView.backgroundColor = [UIColor clearColor];
    
    animationView.animationColor = [UIColor greenColor];
    
    [self.view addSubview:animationView];
    
    //延时调用
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [animationView startUpTimer];
        
        [animationView setPercet:100 withTimer:70];
        
    });

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
