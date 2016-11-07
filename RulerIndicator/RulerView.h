//
//  RulerView.h
//  RulerIndicator
//
//  Created by 张令林 on 2016/11/7.
//  Copyright © 2016年 personer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulerView : UIView

@property (nonatomic,strong) void (^valueBlock)(CGFloat leftvalue, CGFloat rightValue);
//进度可获得的最大值
@property (nonatomic,assign) CGFloat maxValue;
//进度可获得的最小值
@property (nonatomic,assign) CGFloat minValue;
//进度的最小坐标差值
@property (nonatomic,assign) CGFloat minRegion;

@end
