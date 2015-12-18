//
//  ABCCarouselView.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/14.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCCarouselView.h"
#import "UIImageView+WebCache.h"

const NSUInteger KABCScrollInterval = 3;
const NSUInteger KABCanimationInterVal = 0.8;

@interface ABCCarouselView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageNamesArray;

@property (nonatomic, strong) NSMutableArray *imageViewsArray;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, assign) BOOL isRight;

@end

@implementation ABCCarouselView

+ (instancetype)carouselViewWithFrame:(CGRect)frame Images:(NSArray *)images {
    ABCCarouselView *carouselView = [[[self class] alloc] initWithFrame:frame Images:images];
    return carouselView;
}

#pragma mark - Private Method
- (instancetype)initWithFrame:(CGRect)frame Images:(NSArray *)images {
    if (self = [super initWithFrame:frame]) {
        _imageNamesArray = images;
        
        _imageViewsArray = [NSMutableArray arrayWithCapacity:2];
        
        _isRight = YES;
        
        [self addSubview:self.scrollView];
        
        [self addSubview:self.pageControl];
        
        [self addImageViews];
        
        [self addTimer];
    }
    return self;
}

- (void)addImageViews {
    for ( int i = 0; i < 2; i ++) {
        
        CGRect currentFrame = CGRectMake(self.width * i, 0, self.width, self.height);
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:currentFrame];

        [_scrollView addSubview:tempImageView];
        
        [_imageViewsArray addObject:tempImageView];
    }
    
    _scrollView.contentSize = CGSizeMake(self.width * 2, self.height);
    
    UIImageView *tempImageView = _imageViewsArray[0];
    [tempImageView setImage:[UIImage imageNamed:_imageNamesArray[0]]];
}

- (void)addTimer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:KABCScrollInterval target:self selector:@selector(changScrollOffset) userInfo:nil repeats:YES];
    }
}

- (void)changScrollOffset {
    _currentPage++;
    
    if (_currentPage >= _imageNamesArray.count) {
        _currentPage = 0;
    }
    
    if(_currentPage < _imageNamesArray.count){
        UIImageView *tempImageView = _imageViewsArray[1] ;
        [tempImageView setImage:[UIImage imageNamed:_imageNamesArray[_currentPage]]];
    }
    
    [UIView animateWithDuration:KABCanimationInterVal animations:^{
        
        if(_isRight){
            _scrollView.contentOffset = CGPointMake(self.width, 0);
        } else {
            _scrollView.contentOffset = CGPointMake(-self.width, 0);
        }
        
    } completion:^(BOOL finished) {
        if (_currentPage < _imageNamesArray.count) {
            
            _scrollView.contentOffset = CGPointMake(0, 0);
            UIImageView *tempImageView = _imageViewsArray[0] ;
            [tempImageView setImage:[UIImage imageNamed:_imageNamesArray[_currentPage]]];
            
        }
    }];
    
    _pageControl.currentPage = _currentPage;
}

- (void)resumeTimer {
    
    if (![_timer isValid]) {
        return ;
    }
    
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:KABCScrollInterval - KABCanimationInterVal]];
    
}

- (void)LoopRightWithBool: (BOOL) isRight {
    _isRight =isRight;
    UIImageView *secondImageView = _imageViewsArray[1];
    
    if (isRight) {
        secondImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    } else {
        secondImageView.frame = CGRectMake(-self.width, 0, self.width, self.height);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetx = scrollView.contentOffset.x;
    if (offsetx > 3) {
        [self LoopRightWithBool:YES];
        return;
    }
    
    if (offsetx < -3) {
        [self LoopRightWithBool:NO];
        return;
    }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _currentPage ++;
    
    //如果是最后一个图片，让其成为第一个
    if (_currentPage >= _imageNamesArray.count) {
        _currentPage = 0;
    }
    
    //将要显示的视图
    if(_currentPage < _imageNamesArray.count){
        UIImageView *tempImageView = _imageViewsArray[1] ;
        [tempImageView setImage:[UIImage imageNamed:_imageNamesArray[_currentPage]]];
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //说明是用的第二个ImageView
    if (_currentPage < _imageNamesArray.count) {
        
        _scrollView.contentOffset = CGPointMake(0, 0);
        UIImageView *tempImageView = _imageViewsArray[0] ;
        [tempImageView setImage:[UIImage imageNamed:_imageNamesArray[_currentPage]]];
        
    }
    _pageControl.currentPage = _currentPage;
    
    [self resumeTimer];
}

#pragma mark - Setter & Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.userInteractionEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.height - 30, self.width, 20)];
        _pageControl.numberOfPages = _imageNamesArray.count;
        _pageControl.currentPage = _currentPage;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

@end
