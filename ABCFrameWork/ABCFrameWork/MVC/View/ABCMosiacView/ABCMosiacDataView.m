//
//  ABCMosiacDataView.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCMosiacDataView.h"
#import "UIImageView+WebCache.h"

@interface ABCMosiacDataView () <UIGestureRecognizerDelegate>

/**
 *  背景图
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 *  标题栏
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  点击手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;

@end

@implementation ABCMosiacDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.clipsToBounds = YES;
        
        [self addGestureRecognizer:_tapGR];
        
        [self addSubview:_imageView];
        
        [self addSubview:_titleLabel];
    }
    return self;
}

#pragma mark - Masonry
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    WS(weakSelf);
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.top.mas_equalTo(weakSelf.top).offset(weakSelf.width / 2);
    }];
    
    [super updateConstraints];
}

#pragma mark - Private Method
- (void)simpleTapReceived:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapDataView:)]) {
        [_delegate didTapDataView:self];
    }
    [self displayHighlightAnimation];
}

- (void)displayHighlightAnimation {
    self.alpha = 0.3;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL completed){

                     }];
}

-(UIFont *)fontWithModuleSize:(NSUInteger)aSize{
    
    UIFont *retVal = nil;
    
    switch (aSize) {
        case 0:
            retVal = [UIFont systemFontOfSize:36];
            break;
        case 1:
            retVal = [UIFont systemFontOfSize:18];
            break;
        case 2:
            retVal = [UIFont systemFontOfSize:18];
            break;
        case 3:
            retVal = [UIFont systemFontOfSize:15];
            break;
        default:
            retVal = [UIFont systemFontOfSize:15];
            break;
    }
    
    return retVal;
}

#pragma mark - Setter&Getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.alpha = 0.0;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.shadowColor = [UIColor blackColor];
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UITapGestureRecognizer *)tapGR {
    if (!_tapGR) {
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(simpleTapReceived:)];
        _tapGR.numberOfTapsRequired = 1;
        _tapGR.delegate = self;
    }
    return _tapGR;
}

- (void)setDataModel:(ABCMosiacDataModel *)dataModel {
    _dataModel = dataModel;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _imageView.alpha = 1.0;
                } completion:^(BOOL finished) {
                    
                }];
            });
        }
    }];
    
    _titleLabel.text = _dataModel.title;
    _titleLabel.font = [self fontWithModuleSize:_dataModel.imageSize];
}

@end
