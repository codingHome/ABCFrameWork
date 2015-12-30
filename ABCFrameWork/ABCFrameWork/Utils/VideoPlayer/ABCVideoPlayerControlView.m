//
//  ABCVideoPlayerControlView.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/10.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import "ABCVideoPlayerControlView.h"
#import <MediaPlayer/MPVolumeView.h>
#import <AVFoundation/AVFoundation.h>

static const CGFloat kVideoControlBarHeight = 40.0;
static const CGFloat kVideoControlAnimationTimeinterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeinterval = 5.0;

@interface ABCVideoPlayerControlView()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) MPVolumeView *volumeView;

@end

@implementation ABCVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //顶边栏
        [self addSubview:self.topBar];
        
        //底边栏
        [self addSubview:self.bottomBar];
        
        //读取视图
        [self addSubview:self.indicatorView];
        
        //音量视图
        [self addSubview:self.volumeView];
        
        self.pauseButton.hidden = YES;
        
        self.shrinkScreenButton.hidden = YES;
        
        [self addAction];
    }
    return self;
}

- (void)addAction {
    [self.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;

    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:doubleTapGesture];
    
    NSError *error;

    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
        self.volumeView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
        self.volumeView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)playingVideo {
    self.pauseButton.hidden = NO;
    self.playButton.hidden = YES;
    [self.indicatorView stopAnimating];
}
- (void)stopVideo {
    self.pauseButton.hidden = YES;
    self.playButton.hidden = NO;
}

- (void)setProgressSliderCurrentPlayValue:(double)value {
    self.progressSlider.value = ceil(value);
}

- (void)setProgressSliderDuringPlayValue:(double)value {
    self.progressSlider.minimumValue = 0.f;
    self.progressSlider.maximumValue = value;
}

- (void)setTimeLabelText:(NSString *)time {
    self.timeLabel.text = time;
}

- (void)setActivityIndicatorViewAnimation:(BOOL)isOn {
    if (isOn) {
        [self.indicatorView startAnimating];
    }else {
        [self.indicatorView stopAnimating];
    }
}

#pragma mark - Property

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor clearColor];
        
        
        [self.topBar addSubview:self.closeButton];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];

        [self.bottomBar addSubview:self.playButton];
        [self.bottomBar addSubview:self.pauseButton];
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.timeLabel];
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"video-player-play"] forState:UIControlStateNormal];
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"video-player-pause"] forState:UIControlStateNormal];
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"video-player-fullscreen"] forState:UIControlStateNormal];
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"video-player-shrinkscreen"] forState:UIControlStateNormal];
    }
    return _shrinkScreenButton;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"video-player-point"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"video-player-close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}

- (MPVolumeView *)volumeView {
    if (!_volumeView) {
        UISlider* volumeViewSlider = nil;
        _volumeView = [[MPVolumeView alloc] init];
        _volumeView.transform = CGAffineTransformMakeRotation(M_PI_2 + M_PI);
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        float systemVolume = volumeViewSlider.value;
        [volumeViewSlider setThumbImage:[UIImage imageNamed:@"video-player-point"] forState:UIControlStateNormal];
        [volumeViewSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [volumeViewSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        [volumeViewSlider setValue:systemVolume / 10.0 animated:NO];
        
        // send UI control event to make the change effect right now.
        [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return _volumeView;
}

#pragma mark - Action 

- (void)playButtonClick
{
    [self playingVideo];
    if (_delegate && [_delegate respondsToSelector:@selector(didTapPlayerControlViewPlayButton)]) {
        [_delegate didTapPlayerControlViewPlayButton];
    }
}

- (void)pauseButtonClick
{
    [self stopVideo];
    if (_delegate && [_delegate respondsToSelector:@selector(didTapPlayerControlViewPauseButton)]) {
        [_delegate didTapPlayerControlViewPauseButton];
    }
}

- (void)closeButtonClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapPlayerControlViewCloseButton)]) {
        [_delegate didTapPlayerControlViewCloseButton];
    }
}

- (void)fullScreenButtonClick
{
    self.fullScreenButton.hidden = YES;
    self.shrinkScreenButton.hidden = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(didTapPlayerControlViewFullScreenButton)]) {
        [_delegate didTapPlayerControlViewFullScreenButton];
    }
}

- (void)shrinkScreenButtonClick
{
    self.fullScreenButton.hidden = NO;
    self.shrinkScreenButton.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(didTapPlayerControlViewShrinkScreenButton)]) {
        [_delegate didTapPlayerControlViewShrinkScreenButton];
    }
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    if (_delegate && [_delegate respondsToSelector:@selector(didTouchPlayerControlViewProgressSlide:State:)]) {
        [_delegate didTouchPlayerControlViewProgressSlide:slider State:UIControlEventTouchDown];
    }
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    if (_delegate && [_delegate respondsToSelector:@selector(didTouchPlayerControlViewProgressSlide:State:)]) {
        [_delegate didTouchPlayerControlViewProgressSlide:slider State:UIControlEventTouchUpInside];
    }
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    if (_delegate && [_delegate respondsToSelector:@selector(didChangePlayerControlViewProgressSliderValue:)]) {
        [_delegate didChangePlayerControlViewProgressSliderValue:slider];
    }
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture {
    [self animateShow];
    [self stopVideo];
    if (_delegate && [_delegate respondsToSelector:@selector(didDoubleTapPlayerControlView:)]) {
        [_delegate didDoubleTapPlayerControlView:_isBarShowing];
    }
}

#pragma mark - Masonry
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    WS(weakSelf);
    [_topBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top);
        make.left.and.right.mas_equalTo(weakSelf);
        make.width.mas_equalTo(weakSelf.mas_width);
        make.height.mas_equalTo(kVideoControlBarHeight);
    }];
    
    [_bottomBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.left.and.right.mas_equalTo(weakSelf);
        make.width.mas_equalTo(weakSelf.mas_width);
        make.height.mas_equalTo(kVideoControlBarHeight);
    }];
    
    [_playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bottomBar.mas_left);
        make.centerY.mas_equalTo(weakSelf.bottomBar.mas_centerY);
        make.width.and.height.mas_equalTo(kVideoControlBarHeight);
    }];
    
    [_pauseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bottomBar.mas_left);
        make.centerY.mas_equalTo(weakSelf.bottomBar.mas_centerY);
        make.width.and.height.mas_equalTo(kVideoControlBarHeight);
    }];
    
    [_fullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.bottomBar.mas_right);
        make.centerY.mas_equalTo(weakSelf.bottomBar.mas_centerY);
        make.width.and.height.mas_equalTo(kVideoControlBarHeight);
    }];
    
    [_shrinkScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.bottomBar.mas_right);
        make.centerY.mas_equalTo(weakSelf.bottomBar.mas_centerY);
        make.width.and.height.mas_equalTo(kVideoControlBarHeight);
    }];
    
    [_progressSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.playButton.mas_right);
        make.right.mas_equalTo(weakSelf.fullScreenButton.mas_left);
        make.centerY.mas_equalTo(weakSelf.bottomBar.mas_centerY);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.progressSlider.mas_top).offset(-2);
        make.centerX.mas_equalTo(weakSelf.progressSlider.mas_centerX);
        make.width.mas_equalTo(weakSelf.progressSlider.mas_width);
        make.height.mas_equalTo(kVideoControlTimeLabelFontSize);
    }];
    
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.topBar.mas_right);
        make.top.mas_equalTo(weakSelf.topBar.mas_top);
        make.width.and.height.mas_equalTo(kVideoControlBarHeight);
    }];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.center);
    }];
    
    [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.mas_right);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(weakSelf.height / 3);
    }];
    
    [super updateConstraints];
}

@end
