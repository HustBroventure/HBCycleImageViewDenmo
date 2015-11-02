//
//  HBCycleImageView.h
//  HBCycleImageView
//
//  Created by wangfeng on 15/11/2.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickImageBlock)(NSInteger index);
@interface HBCycleImageView : UIView
@property (nonatomic, copy) ClickImageBlock clickImageBlock;
    //切换图片的时间间隔，可选，默认为3s
@property (nonatomic, assign) CGFloat timeInterval;

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;
@end
