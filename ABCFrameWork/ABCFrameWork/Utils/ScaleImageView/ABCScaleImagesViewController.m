//
//  ABCScaleImagesViewController.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/23.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCScaleImagesViewController.h"
#import "ABCScaleImageView.h"
#import "UIImage+ImageProcessing.h"

@interface ABCScaleImagesViewController () <UIScrollViewDelegate, UIActionSheetDelegate>

//上一张
@property (nonatomic, strong) ABCScaleImageView *preImage;
//当前图片
@property (nonatomic, strong) ABCScaleImageView *currentImage;
//下一张
@property (nonatomic, strong) ABCScaleImageView *nextImage;
//当前页
@property (nonatomic, assign) NSInteger imagePage;

@property (nonatomic, strong) UIScrollView *scrollView;

//纪录需要放大的图片
@property (nonatomic, strong) ABCScaleImageView *scaleImageView;

@end

@implementation ABCScaleImagesViewController

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.imagePage = [self.imagePaths indexOfObject:self.currentImagePath];
    
    [self.view addSubview:self.scrollView];
    
    [self initImageViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

#pragma mark - Action
- (void)cancel:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Private Method
- (void)initImageViews {
    if (self.imagePaths.count == 0) {
        return;
    }
    
    if (self.imagePage >= 1) {
        _preImage.image = [self getImage:(self.imagePage -1)];
    }else {
        _preImage.image = nil;
    }
    
    if (self.imagePage <= self.imagePaths.count - 2 && self.imagePaths.count >= 2) {
        _nextImage.image = [self getImage:(self.imagePage +1)];
    }else {
        _nextImage.image = nil;
    }
    _currentImage.image = [self getImage:self.imagePage];
}

- (UIImage *)getImage:(NSInteger)index {
//    UIImage *image = [UIImage imageWithContentsOfFile:[self.imagePaths objectAtIndex:index]];
    NSString *imageName = [NSString stringWithFormat:@"00%d.jpg",index + 1];
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageByScalingToSize:CGSizeMake(self.view.width * 3, self.view.height * 3)];
    return image;
}

//左滑
- (void)scrollLeft
{
    if (self.imagePage <= self.imagePaths.count - 2 && self.imagePaths.count >= 2) {
        _nextImage.image = _currentImage.image;
    }else {
        _nextImage.image = nil;
    }
    
    _currentImage.image = _preImage.image;
    
    if (self.imagePage >= 1) {
        self.scaleImageView = _preImage;
        _preImage.image = [self getImage:(self.imagePage -1)];
    } else {
        _preImage.image = nil;
    }
}

//右滑
- (void)scrollRight
{
    if (self.imagePage >= 1) {
        _preImage.image = _currentImage.image;
    } else {
        _preImage.image = nil;
    }
    
    _currentImage.image = _nextImage.image;
    
    if (self.imagePage <= self.imagePaths.count - 2 && self.imagePaths.count >= 2) {
        self.scaleImageView = _nextImage;
        _nextImage.image = [self getImage:(self.imagePage +1)];
    }else {
        _nextImage.image = nil;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.imagePage == self.imagePaths.count - 1 && scrollView.contentOffset.x > self.view.width + self.view.width/4) {
        CGPoint point = scrollView.contentOffset;
        point.x = self.view.width + self.view.width/4;
        scrollView.contentOffset = point;
        return;
    } else if(self.imagePage == 0 && scrollView.contentOffset.x < 3 *self.view.width/4) {
        CGPoint point = scrollView.contentOffset;
        point.x =  3 * self.view.width/4;
        scrollView.contentOffset = point;
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.currentImage  restScale];
    if (scrollView.contentOffset.x > self.view.width) {
        //右翻页
        if (self.imagePage > self.imagePaths.count - 2 || self.imagePaths.count < 2) {
            [scrollView scrollRectToVisible:CGRectMake(self.view.width, 0, self.view.width ,self.scrollView.frame.size.height) animated:YES];
            return;
        }
        self.imagePage ++;
        [self scrollRight];
    }else if (scrollView.contentOffset.x < self.view.width) {
        //左翻页
        if (self.imagePage < 1) {
            [scrollView scrollRectToVisible:CGRectMake(self.view.width, 0, self.view.width, self.scrollView.frame.size.height) animated:YES];
            return;
        }
        self.imagePage --;
        [self scrollLeft];
    }

    [scrollView scrollRectToVisible:CGRectMake(self.view.width, 0, self.view.width, self.scrollView.frame.size.height) animated:NO];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(self.currentImage.image, nil, nil, nil);
        AlertlogError(@"保存成功");
    }
}

#pragma mark - Setter && Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollView.contentSize = CGSizeMake(self.view.width *3 , self.view.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(self.view.width, 0);
        
        [_scrollView addSubview:self.preImage];
        [_scrollView addSubview:self.currentImage];
        [_scrollView addSubview:self.nextImage];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
        [self.scrollView addGestureRecognizer:tap];
        
    }
    return _scrollView;
}

- (ABCScaleImageView *)preImage {
    if (!_preImage) {
        _preImage = [[ABCScaleImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    }
    return _preImage;
}

- (ABCScaleImageView *)currentImage {
    if (!_currentImage) {
        _currentImage = [[ABCScaleImageView alloc] initWithFrame:CGRectMake(_preImage.right, 0, self.view.width, self.view.height)];
    }
    return _currentImage;
}

- (ABCScaleImageView *)nextImage {
    if (!_nextImage) {
        _nextImage = [[ABCScaleImageView alloc] initWithFrame:CGRectMake(_currentImage.right, 0, self.view.width, self.view.height)];
    }
    return _nextImage;
}

@end
