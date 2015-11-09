//
//  HBReuseCycleImageView.m
//  HBCycleImageView
//
//  Created by wangfeng on 15/11/9.
//  Copyright (c) 2015年 HustBroventurre. All rights reserved.
//

#import "HBReuseCycleImageView.h"
#import "UIImageView+AFNetworking.h"
@interface HBReuseCycleImageView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation HBReuseCycleImageView
{
    CGFloat _widthOfView;
    CGFloat _heightView;
    NSInteger _currentPage;
    
}
#pragma mark - public methords
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    if(self = [super initWithFrame:frame]){
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:imageArray.lastObject];
        [_dataArray addObjectsFromArray:imageArray];
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
    _timeInterval = 3;
        //当前显示页面
    _currentPage = 1;
    self.clipsToBounds = YES;
        //初始化滚动视图
    [self addSubview:self.collectionView];
    
        //添加timer
        // [self addTimerLoop];
        [self addSubview:self.pageControl];
    
}
- (void) addTimerLoop
{
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
    }
}
-(void) changeOffset
{
    _currentPage++;
    if (_currentPage == _dataArray.count ) {
        _currentPage = 1;
    }
    
     [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    if (_currentPage == _dataArray.count - 1) {
//        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
//[_collectionView scrollsToTop];
             [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];

    }

//    [UIView animateWithDuration:0.6 animations:^{
//        [_collectionView setContentOffset:CGPointMake(_widthOfView * _currentPage, 0) animated:NO];
//    } completion:^(BOOL finished) {
//        if (_currentPage == _dataArray.count - 1) {
//            [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
//        }
//    }];
    _pageControl.currentPage = _currentPage - 1;
    
}

#pragma mark - property-setter-getter
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
            //_collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HBCollectionViewCell class] forCellWithReuseIdentifier:@"CELLID"];
        _collectionView.contentOffset = CGPointMake(_widthOfView, 0);
        
        
    }
    return _collectionView;
}
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightView - 20, _widthOfView, 20)];
        _pageControl.numberOfPages = _dataArray.count - 1;
        _pageControl.currentPage = _currentPage - 1;
        
    }
    return _pageControl;
}
#pragma mark - event methords


#pragma mark - delegate methords
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CELLID";
    HBCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor grayColor];
    cell.imageView.image = _dataArray[indexPath.row] ;

    if ([_dataArray[indexPath.row] isKindOfClass:[UIImage class]]) {
           }else{
            NSURL* URL = [NSURL URLWithString:_dataArray[indexPath.row]];
        [cell.imageView setImageWithURL:URL placeholderImage:self.placeHolderImage];
        
    
    }
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    if (index == 0) {
        index = _dataArray.count;
    }
    if (self.clickImageBlock) {
        
        self.clickImageBlock(index - 1);
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / _widthOfView;
    _currentPage = currentPage;
    _pageControl.currentPage = _currentPage-1;
    if(currentPage == 0){
        _pageControl.currentPage = _dataArray.count-1;
    }
    [self resumeTimer];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0) {
        [_collectionView setContentOffset:CGPointMake(_dataArray.count*_widthOfView, 0) animated:NO];
    }
    if (scrollView.contentOffset.x > (_dataArray.count - 1)*_widthOfView) {
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
        
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
@implementation HBCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [UIImageView new];
        self.imageView.backgroundColor = [UIColor clearColor];
      
        [self.contentView addSubview:self.imageView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
      self.imageView.frame = self.contentView.bounds;
}
@end
