//
//  HBCycleImageView.m
//  HBCycleImageView
//
//  Created by wangfeng on 15/11/2.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import "HBCycleImageView.h"
#import "UIButton+AFNetworking.h"
@interface HBCycleImageView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSArray *imageViewArray;
@property (nonatomic, strong) NSTimer *timer;


@end
@implementation HBCycleImageView
{
     CGFloat _widthOfView;

     CGFloat _heightView;
    NSInteger _currentPage;

}
#pragma mark - public methords
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    if(self = [super initWithFrame:frame]){
        _imageViewArray = imageArray;
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame imageURLArray:(NSArray *)imageURLArray
{
    if(self = [super initWithFrame:frame]){
        _imageViewArray = imageURLArray;
        [self commonInit];
    }
    return self;
}
#pragma mark - private-tools methords
-(void)commonInit
{
        //宽度
    _widthOfView = self.frame.size.width;
        //高度
    _heightView = self.frame.size.height;
    
    _timeInterval = 2;
    
        //当前显示页面
    _currentPage = 1;
    self.clipsToBounds = YES;
        //初始化滚动视图
    [self addSubview:self.scrollView];
    
        //添加ImageView
    [self addImageviewsWithImages:_imageViewArray];
        //添加timer
    [self addTimerLoop];
    [self addSubview:self.pageControl];

}
- (void)addImageviewsWithImages:(NSArray*)imageArray
{
    NSInteger count = imageArray.count;
    if (count == 0){
        return;
    }
    self.scrollView.contentSize = CGSizeMake(_widthOfView * (count+1), 0);
    self.scrollView.contentOffset = CGPointMake(_widthOfView, 0);

    for (int i = 0; i < count; i++) {
        UIButton* item = [self createButtonItem];
        
        item.tag = i;
        if ([imageArray[i] isKindOfClass:[UIImage class]]) {
            [item setBackgroundImage:imageArray[i] forState:UIControlStateNormal];
        }else{
            NSURL* URL = [NSURL URLWithString:imageArray[i]];
            [item setBackgroundImageForState:UIControlStateNormal withURL:URL placeholderImage:self.placeHolderImage];
        }
        item.frame = CGRectMake((i+1)*_widthOfView, 0, _widthOfView, _heightView);
        [self.scrollView addSubview:item];
    }

    UIButton* itemZero = [self createButtonItem];
    [itemZero setBackgroundImage:imageArray[count-1] forState:UIControlStateNormal];
    itemZero.tag = count-1;
    itemZero.frame = CGRectMake(0, 0, _widthOfView, _heightView);
    [self.scrollView addSubview:itemZero];


}
-(UIButton*)createButtonItem
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void) addTimerLoop
{

    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
    }
}
-(void) changeOffset
{
    _currentPage ++;
    if (_currentPage == _imageViewArray.count + 1) {
        _currentPage = 1;
    }

    [UIView animateWithDuration:0.6 animations:^{
        _scrollView.contentOffset = CGPointMake(_widthOfView * _currentPage, 0);
    } completion:^(BOOL finished) {
        if (_currentPage == _imageViewArray.count) {
                //_scrollView.contentOffset = CGPointMake(0, 0);
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }];
    _pageControl.currentPage = _currentPage - 1;

}

#pragma mark - property-setter-getter
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightView - 20, _widthOfView, 20)];
        _pageControl.numberOfPages = _imageViewArray.count;
        _pageControl.currentPage = _currentPage - 1;

    }
    return _pageControl;
}
#pragma mark - event methords
-(void)click:(UIButton*)sender
{
    NSLog(@"%s   %ld",__func__,sender.tag);
    if (self.clickImageBlock) {
        self.clickImageBlock(sender.tag);
    }

}

#pragma mark - delegate methords

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger currentPage = scrollView.contentOffset.x / _widthOfView;
    if(currentPage == 0){
        _pageControl.currentPage = _imageViewArray.count;
        _currentPage = _imageViewArray.count;
    }
    if (_currentPage + 1 == currentPage || currentPage == 1) {
        _currentPage = currentPage;

        if (_currentPage == _imageViewArray.count + 1) {
            _currentPage = 1;
        }
        _pageControl.currentPage = _currentPage - 1;
        [self resumeTimer];
        return;
    }


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0) {
        [_scrollView setContentOffset:CGPointMake(_imageViewArray.count*_widthOfView, 0) animated:NO];
           }
    if (scrollView.contentOffset.x > _imageViewArray.count*_widthOfView) {
         [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
       
    }

}
#pragma 暂停定时器
-(void)resumeTimer{

    if (![_timer isValid]) {
        return ;
    }
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval-0.1]];

}



@end
