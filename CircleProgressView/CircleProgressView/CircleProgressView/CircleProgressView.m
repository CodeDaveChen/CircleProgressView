//
//  CircleProgressView.m
//  CircleProgressView
//
//  Created by 陈舟为 on 2017/3/21.
//  Copyright © 2017年 DaveChen. All rights reserved.
//

#import "CircleProgressView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kWidths 40 //进度条宽
#define kHeights 40 //进度条高

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define PROGREESS_WIDTH 50 //圆直径
#define PROGRESS_LINE_WIDTH 5 //弧线的宽度

@implementation CircleProgressView

+ (instancetype)circleViewShowInView:(UIView *)view {
    
    CGFloat width = CGRectGetWidth(view.frame);
    CGFloat height = CGRectGetHeight(view.frame);
    CGFloat x = (width - kWidths ) /  2;
    CGFloat y = (height - kHeights ) /  2;
    if (height > kScreenHeight) {
        y = (kScreenHeight - kHeights) / 2;
    }
    CircleProgressView *circle = [[self alloc] initWithFrame:CGRectMake(x, y, kWidths, kHeights)];
    circle.backgroundColor = [UIColor clearColor];
    [view addSubview:circle];
    
    return circle;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
- (void)hide {
    self.hidden = YES;
    [self removeFromSuperview];
}

- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    _circleBackgroundColor = _circleBackgroundColor ? : [UIColor colorWithWhite:0 alpha:.6];
    _circleLineColor = _circleLineColor ? : [UIColor whiteColor];
    //黑色背景
    CGFloat minWidth = rect.size.width < rect.size.height ?: rect.size.height;
    CGPoint center = CGPointMake(minWidth / 2,minWidth / 2 );
    CGFloat startAngle = -M_PI_2;
    UIBezierPath *backgroundCircle = [UIBezierPath bezierPathWithArcCenter:center radius:minWidth / 2 startAngle:startAngle endAngle:M_PI * 2 + startAngle clockwise:YES];
    [_circleBackgroundColor setFill];
    [backgroundCircle fill];
    
    //圆形进度条
    CGFloat endAngle = _progress * M_PI * 2 + startAngle;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:minWidth / 2 - 7 startAngle:startAngle endAngle:endAngle clockwise:YES];
    path.lineWidth = 3;
    path.lineCapStyle = kCGLineCapRound;
    [_circleLineColor setStroke];
    [path stroke];
}


@end

@interface CircleProgressViewWithAnimation()

@property (nonatomic, weak) CAShapeLayer *progressLayer;

@property(nonatomic,weak)UILabel *textLab;

@property(nonatomic,weak)NSTimer *timer;

@property (assign, nonatomic) NSTimeInterval durationToValidity;

@end

@implementation CircleProgressViewWithAnimation

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
        
        label.textColor = [UIColor blackColor];
        
        label.textAlignment = 1;
        
        label.font = [UIFont systemFontOfSize:12];
        
        label.text = @"60s";
        
        [self addSubview:label];
        
        self.textLab = label;
        
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    // 创建一个tracker(轨道layer)
    CAShapeLayer *trackLayer = [CAShapeLayer layer];
    trackLayer.frame = rect;
    [self.layer addSublayer:trackLayer];
    trackLayer.fillColor = [UIColor clearColor].CGColor;
    trackLayer.strokeColor = [UIColor whiteColor].CGColor;
    // 背景透明度
    trackLayer.opacity = 1.0f;
    trackLayer.lineCap = kCALineCapRound;
    trackLayer.lineWidth = PROGRESS_LINE_WIDTH;
    // 创建轨道
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:rect.size.width / 2 - PROGRESS_LINE_WIDTH / 2 startAngle:degreesToRadians(-90) endAngle:degreesToRadians(270) clockwise:YES];
    trackLayer.path = [path CGPath];
    
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:rect.size.width / 2 - PROGRESS_LINE_WIDTH / 2 startAngle:degreesToRadians(PROGRESS_LINE_WIDTH / 2 - 90) endAngle:degreesToRadians(270 - PROGRESS_LINE_WIDTH / 2) clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = rect;
    
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
    progressLayer.path = [path CGPath];
    progressLayer.strokeEnd = 0;
    self.progressLayer = progressLayer;
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, rect.size.width / 2, rect.size.height);
    [gradientLayer1 setStartPoint:CGPointMake(0.5, 1)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer addSublayer:gradientLayer1];
    gradientLayer1.colors = @[(id)self.animationColor.CGColor,(id)self.animationColor.CGColor];
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(rect.size.width / 2, 0, rect.size.width / 2, rect.size.height);
    gradientLayer2.colors = @[(id)self.animationColor.CGColor,(id)self.animationColor.CGColor];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer addSublayer:gradientLayer2];
    
    // progressLayer来截取渐变层, fill是clear stroke有颜色
    [gradientLayer setMask:progressLayer];
    
    [self.layer addSublayer:gradientLayer];
    
}

- (void)startUpTimer{
    
    self.userInteractionEnabled = NO;
    
    _durationToValidity = 60;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleDisplayLink:) userInfo:nil repeats:YES];
    
}

- (void)endUPTimer{
    
    self.textLab.text = @"发送";
    
    [self setNeedsDisplay];
    
    [self.timer invalidate];
    
    self.timer = nil;
    
    self.userInteractionEnabled = YES;
}

- (void)invalidateTimer{
    [self setNeedsDisplay];
    [self.timer invalidate];
    self.timer = nil;
    
    self.userInteractionEnabled = YES;
    
}

- (void)handleDisplayLink:(NSTimer *)timer {
    
    _durationToValidity --;
    
    if (_durationToValidity > 0) {
        
        self.textLab.text = [NSString stringWithFormat:@"%.0lf s",_durationToValidity];
        
    }else{
        
        self.textLab.text = @"发送";
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setNeedsDisplay];
        
        [self invalidateTimer];
    }
}

- (void)setPercet:(CGFloat)percent withTimer:(CGFloat)time {
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [CATransaction setAnimationDuration:time];
    _progressLayer.strokeEnd = percent / 100.0f;
    [CATransaction commit];
}


@end
