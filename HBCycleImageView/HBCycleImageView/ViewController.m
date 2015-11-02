//
//  ViewController.m
//  HBCycleImageView
//
//  Created by wangfeng on 15/11/2.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import "ViewController.h"
#import "HBCycleImageView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HBCycleImageView* view = [[HBCycleImageView alloc]initWithFrame:CGRectMake(0, 100, 375, 200) imageArray:@[[UIImage imageNamed:@"01.jpg"],[UIImage imageNamed:@"02.jpg"],[UIImage imageNamed:@"03.jpg"]]];

    [self.view addSubview:view];
}



@end
