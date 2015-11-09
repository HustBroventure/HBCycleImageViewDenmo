//
//  HBReuseCycleImageView.h
//  HBCycleImageView
//
//  Created by wangfeng on 15/11/9.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClickImageBlock)(NSInteger index);

@interface HBReuseCycleImageView : UIView
@property (nonatomic, copy) ClickImageBlock clickImageBlock;
    //切换图片的时间间隔，可选，默认为2s
@property (nonatomic, assign) CGFloat timeInterval;
@property (nonatomic, strong) UIImage* placeHolderImage;
@property (nonatomic, strong) UIPageControl *pageControl;

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

-(void)reloadWithDataArray:(NSArray*)dataArray;
@end

@interface HBCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView* imageView;
@end