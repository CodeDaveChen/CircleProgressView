//
//  CircleProgressView.h
//  CircleProgressView
//
//  Created by 陈舟为 on 2017/3/21.
//  Copyright © 2017年 DaveChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

//背景颜色
@property (nonatomic,strong)UIColor *circleBackgroundColor;

//进度条颜色
@property (nonatomic,strong)UIColor *circleLineColor;

//进度(0-1)
@property (nonatomic,assign)CGFloat progress;

+ (instancetype)circleViewShowInView:(UIView *)view;

- (void)hide;


@end


@interface CircleProgressViewWithAnimation : UIView

/**
 * 开始动画
 * percent CGFloat 百分比(0-100)
 * time CGFloat 动画时间
 */
- (void)setPercet:(CGFloat)percent withTimer:(CGFloat)time ;

- (void)startUpTimer;
- (void)endUPTimer;
- (void)invalidateTimer;

//动画的颜色
@property(nonatomic,strong)UIColor *animationColor;

@property(nonatomic,copy)void(^block)();

@end
