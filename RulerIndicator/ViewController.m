//
//  ViewController.m
//  RulerIndicator
//
//  Created by 张令林 on 2016/11/7.
//  Copyright © 2016年 personer. All rights reserved.
//

#import "ViewController.h"
#import "RulerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //调用初始化方法
    [self setUpUI];
}

#pragma mark 初始化方法
- (void)setUpUI
{
    self.view.backgroundColor = [UIColor orangeColor];
    
    RulerView *rulerView = [[RulerView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, self.view.bounds.size.height)];
    rulerView.backgroundColor = [UIColor whiteColor];
    rulerView.valueBlock = ^(CGFloat leftvalue, CGFloat rightValue){
        NSLog(@"%lf------%lf",leftvalue,rightValue);
    };
    [self.view addSubview:rulerView];
}

@end
