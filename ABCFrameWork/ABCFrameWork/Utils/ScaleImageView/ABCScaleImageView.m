//
//  ABCScaleImageView.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/23.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCScaleImageView.h"
#import "ABCRoundButton.h"

static const CGFloat KABCMinimumZoomScale = 0.5;

static const CGFloat KABCMaximumZoomScale = 3.0;

@interface ABCScaleImageView () <UIScrollViewDelegate>

/**
 *  放大缩小图片用
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  显示图片用
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 *  保存图片用
 */
@property (nonatomic, strong) ABCRoundButton *saveButton;

@end

@implementation ABCScaleImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.saveButton];
    }
    return self;
}

#pragma mark - Masonry
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    WS(weakSelf);
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-10);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(25);
    }];
    
    [super updateConstraints];
}

#pragma mark - Action
- (void)saveImage {
    if (_scrollView.zoomScale != 1.0) {
        [self.scrollView zoomToRect:self.bounds animated:YES];
    }
    UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
    AlertlogError(@"保存成功");
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale == 1.0) {
        CGPoint point = [tap locationInView:self];
        
        CGFloat zoomWidth = self.width / KABCMaximumZoomScale;
        CGFloat zoomHeight = self.height / KABCMaximumZoomScale;
        
        [self.scrollView zoomToRect:CGRectMake(point.x - zoomWidth / 2, point.y - zoomHeight / 2, zoomWidth, zoomHeight) animated:YES];
        
    }else {
        [self.scrollView zoomToRect:self.bounds animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setScrollViewContentInset];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark - Private Method
- (void)setScrollViewContentInset {
    CGSize imageViewSize = self.imageView.size;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0;
    CGFloat horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding);
}

#pragma mark - Setter && Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.minimumZoomScale = KABCMinimumZoomScale;
        _scrollView.maximumZoomScale = KABCMaximumZoomScale;
        _scrollView.delegate = self;
        [_scrollView addSubview:self.imageView];
        
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = self.image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[ABCRoundButton alloc] init];
        _saveButton.backgroundColor = [UIColor blackColor];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
