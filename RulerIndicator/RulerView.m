//
//  RulerView.m
//  RulerIndicator
//
//  Created by 张令林 on 2016/11/7.
//  Copyright © 2016年 personer. All rights reserved.
//

#import "RulerView.h"

#define W self.bounds.size.width
#define H self.bounds.size.height
#define HandImageViewW  20.0*radio
#define HandImageViewH  25.0*radio
#define ProgressViewH  2.0*radio
#define PRICEBGW  (W-HandImageViewW)
#define PRICEBGH  PRICEBGW/271.0*21.0

#define PRICEMAX  (W - HandImageViewW*0.5)
#define PRICEMIN  HandImageViewW*0.5

@interface RulerView ()
{
    UIImageView *leftHandImageView;
    UIImageView *rightHandImageView;
    UIView *progressView;
    //缩放的倍数
    CGFloat radio;
    float leftValue;
    float rightValue;
    float leftLocation;
    float rightLocation;
}

@end

@implementation RulerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    leftValue = 0.f;
    rightValue = 100.f;
    _minValue = 0.f;
    _maxValue = 100.f;
    _minRegion = HandImageViewW;
    //相对于屏幕缩放的倍数
    radio = self.bounds.size.width/[UIScreen mainScreen].bounds.size.width;
    
    [self setUpView];
}

-(void)setUpView{
    
    //刻度背景图
    UIImageView *priceBg = [[UIImageView alloc] initWithFrame:CGRectMake(0.5*HandImageViewW, 0, PRICEBGW, PRICEBGH)];
    [priceBg setImage:[UIImage imageNamed:@"priceRuler"]];
    [self addSubview:priceBg];
    
    //蓝色进度条
    progressView = [[UIView alloc] initWithFrame:CGRectMake(0.5*HandImageViewW, CGRectGetMaxY(priceBg.frame)-ProgressViewH, W-HandImageViewW, ProgressViewH)];
    [progressView setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:144.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self addSubview:progressView];
    
    //左把手
    CGFloat leftHandImageViewX = 0;
    CGFloat leftHandImageViewY = progressView.frame.origin.y;
    leftHandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftHandImageViewX, leftHandImageViewY, HandImageViewW, HandImageViewH)];
    [leftHandImageView setImage:[UIImage imageNamed:@"xiabashou"]];
    [self addSubview:leftHandImageView];
    
    //右把手
    CGFloat rightHandImageViewX = W - HandImageViewW;
    CGFloat rightHandImageViewY = leftHandImageViewY;
    rightHandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(rightHandImageViewX, rightHandImageViewY, HandImageViewW, HandImageViewH)];
    [rightHandImageView setImage:[UIImage imageNamed:@"xiabashou"]];
    [self addSubview:rightHandImageView];
    
    //左把手添加滑动手势
    UIPanGestureRecognizer *leftPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandMove:)];
    [leftPanRecognizer setMinimumNumberOfTouches:1];
    [leftPanRecognizer setMaximumNumberOfTouches:1];
    [leftHandImageView setUserInteractionEnabled:YES];
    [leftHandImageView addGestureRecognizer:leftPanRecognizer];
    
    //右把手添加滑动手势
    UIPanGestureRecognizer *rightPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandMove:)];
    [rightHandImageView setUserInteractionEnabled:YES];
    [rightHandImageView addGestureRecognizer:rightPanRecognizer];
    
//    [self updateData];
}
#pragma mark - 手势的执行方法
-(void)leftHandMove:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:leftHandImageView];
    CGFloat x = leftHandImageView.center.x + point.x;
    
    if(x > PRICEMAX)
    {
        x = PRICEMAX;
    }else if (x < PRICEMIN )
    {
        x = PRICEMIN;
    }else if (x > rightLocation-HandImageViewW)
    {
        x = rightLocation-HandImageViewW;
    }
    leftLocation = x;
    leftValue = [self getValueByLocation:x];
    leftHandImageView.center = CGPointMake(x, leftHandImageView.center.y);
    
    [pan setTranslation:CGPointZero inView:self];
    [self updateData];
}

-(void)rightHandMove:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:rightHandImageView];
    CGFloat x = rightHandImageView.center.x + point.x;

    
    if(x>PRICEMAX){
        x = PRICEMAX;
    }else if (x<leftLocation+HandImageViewW){
        x = leftLocation+HandImageViewW;
    }else if (x<PRICEMIN){
        x = PRICEMIN;
    }
    rightLocation = x;
    rightValue = [self getValueByLocation:x];
    rightHandImageView.center = CGPointMake(x, rightHandImageView.center.y);
    
    
    [pan setTranslation:CGPointZero inView:self];
    [self updateData];
}
#pragma mark - 获取坐标和坐标对应数值
- (CGFloat)getValueByLocation:(CGFloat)x
{
    CGFloat valueRegion = self.maxValue - self.minValue;
    CGFloat locationRegion = PRICEBGW;
    
    CGFloat offSetX = x - HandImageViewW*0.5;
    
    return valueRegion*offSetX/locationRegion;
}

-(void)updateData{
    CGRect progressRect = CGRectMake(leftHandImageView.center.x, progressView.frame.origin.y, rightHandImageView.center.x - leftHandImageView.center.x, progressView.frame.size.height);
    progressView.frame = progressRect;
    //block返回结果
    self.valueBlock(leftValue,rightValue);
}

-(void)setFrame:(CGRect)frame
{
    radio = frame.size.width/[UIScreen mainScreen].bounds.size.width;
    frame.size.height = HandImageViewH+PRICEBGH;
    leftLocation = PRICEMIN;
    rightLocation = PRICEMAX;
    [super setFrame:frame];
}

@end
