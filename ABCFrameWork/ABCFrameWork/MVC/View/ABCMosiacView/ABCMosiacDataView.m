//
//  ABCMosiacDataView.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 Robert. All rights reserved.
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

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, assign) CGFloat titleHeight;

@end

@implementation ABCMosiacDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.clipsToBounds = YES;

        [self addGestureRecognizer:self.tapGR];
        
        [self addSubview:self.imageView];
        
        [self addSubview:self.titleLabel];
        
        _imageSize = CGSizeMake(self.width, self.height);
        
        _titleHeight = 15;
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
        make.top.mas_equalTo(weakSelf.mas_top);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.width.mas_equalTo(weakSelf.imageSize.width);
        make.height.mas_equalTo(weakSelf.imageSize.height);
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf).offset(5);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).offset(-5);
        make.height.mas_equalTo(weakSelf.titleHeight);
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
            self.titleHeight = 36;
            break;
        case 1:
            retVal = [UIFont systemFontOfSize:18];
            self.titleHeight = 18;
            break;
        case 2:
            retVal = [UIFont systemFontOfSize:18];
            self.titleHeight = 18;
            break;
        case 3:
            retVal = [UIFont systemFontOfSize:15];
            self.titleHeight = 15;
            break;
        default:
            retVal = [UIFont systemFontOfSize:15];
            self.titleHeight = 15;
            break;
    }
    
    return retVal;
}

#pragma mark - Setter&Getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
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
    
    
    _titleLabel.text = _dataModel.title;
    _titleLabel.font = [self fontWithModuleSize:_dataModel.imageSize];
    
    NSDictionary *attribute = @{NSFontAttributeName: self.titleLabel.font};
    
    CGSize newSize = [dataModel.title boundingRectWithSize:self.titleLabel.size
                                                   options:
                      NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:attribute context:nil].size;
    
    self.titleHeight = newSize.height;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_dataModel.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CGSize imgFinalSize = CGSizeZero;
                
                if (image.size.width < image.size.height){
                    imgFinalSize.width = self.bounds.size.width;
                    imgFinalSize.height = self.bounds.size.width * image.size.height / image.size.width;
                    
                    if (imgFinalSize.height < self.bounds.size.height){
                        imgFinalSize.width = self.bounds.size.height * self.bounds.size.width / imgFinalSize.height;
                        imgFinalSize.height = self.bounds.size.height;
                    }
                }else{
                    imgFinalSize.height = self.bounds.size.height;
                    imgFinalSize.width = self.bounds.size.height * image.size.width / image.size.height;
                    
                    if (imgFinalSize.width < self.bounds.size.width){
                        imgFinalSize.height = self.bounds.size.height * self.bounds.size.width / imgFinalSize.height;
                        imgFinalSize.width = self.bounds.size.width;
                    }
                }
                
                self.imageSize = imgFinalSize;
                
                [self setNeedsUpdateConstraints];
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _imageView.alpha = 1.0;
                } completion:^(BOOL finished) {
                    
                }];
                
            });
        }
    }];
}

@end
