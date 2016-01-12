//
//  ABCLoadingView.m
//  ABCFrameWork
//
//  Created by Robert on 16/1/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ABCLoadingView.h"
#import <pop/POP.h>

@interface ABCLoadingView ()

@property (nonatomic, strong) UIView            *contentView;

@property (nonatomic, strong) UIImageView       *logoImageView;

@property (nonatomic, strong) UIImageView       *loopImageView;

@property (nonatomic, assign) BOOL              isLoading;

@property (nonatomic, strong) POPBasicAnimation *rotationAnimation;

@property (nonatomic, strong) POPBasicAnimation *alphaOutAnimation;

@end

@implementation ABCLoadingView

-(instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.contentView];
        self.alpha = 0.0;
    }
    return self;
}

- (void)startAnimating {
    self.isLoading = YES;
    
    POPBasicAnimation *hiddenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    hiddenAnimation.fromValue = @(0.0f);
    hiddenAnimation.toValue = @(1.0f);
    hiddenAnimation.duration = 0.35f;
    hiddenAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self animationStaff];
    };
    hiddenAnimation.removedOnCompletion = YES;
    [self pop_addAnimation:hiddenAnimation forKey:@"hidden"];
}

- (void)animationStaff {
    self.rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    self.rotationAnimation.fromValue = @(0);
    self.rotationAnimation.toValue = @(M_PI * 2);
    self.rotationAnimation.duration = 1.0f;
    self.rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.rotationAnimation.repeatForever = YES;
    [self.loopImageView.layer pop_addAnimation:self.rotationAnimation forKey:@"rotaion"];
    
    self.alphaOutAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    self.alphaOutAnimation.fromValue = @(1.0);
    self.alphaOutAnimation.toValue = @(0.6);
    self.alphaOutAnimation.duration = 1.0f;
    self.alphaOutAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.alphaOutAnimation.repeatForever = YES;
    self.alphaOutAnimation.autoreverses = YES;
    [self.logoImageView pop_addAnimation:self.alphaOutAnimation forKey:@"alphaOut"];
}

- (void)stopAnimating {
    self.isLoading = NO;
    
    POPBasicAnimation *reHiddenAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    reHiddenAnimation.fromValue = @(1.0f);
    reHiddenAnimation.toValue = @(0.0f);
    reHiddenAnimation.duration = 0.35f;
    reHiddenAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self.loopImageView.layer pop_removeAnimationForKey:@"rotaion"];
        [self.logoImageView pop_removeAnimationForKey:@"alphaOut"];
    };
    reHiddenAnimation.removedOnCompletion = YES;
    [self pop_addAnimation:reHiddenAnimation forKey:@"reHidden"];
}

#pragma mark - Setter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.loopImageView];
        [_contentView addSubview:self.logoImageView];
    }
    return _contentView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"loading_logo"];
    }
    return _logoImageView;
}

-(UIImageView *)loopImageView {
    if (!_loopImageView) {
        _loopImageView = [[UIImageView alloc] init];
        _loopImageView.image = [UIImage imageNamed:@"loading_loop"];
    }
    return _loopImageView;
}

#pragma mark - Masonry
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    WS(weakSelf);
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf);
    }];
    
    [_loopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.contentView);
    }];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.contentView);
    }];
    
    [super updateConstraints];
}

@end
