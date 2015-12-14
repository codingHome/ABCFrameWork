//
//  ABCVidepPlayerController.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/10.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCVidepPlayerController.h"
#import "ABCVideoPlayerControlView.h"

static const CGFloat kVideoPlayerControllerAnimationTimeinterval = 0.3f;

@interface ABCVidepPlayerController () <ABCVideoPlayerControlViewDelegate>

@property (nonatomic, strong) ABCVideoPlayerControlView *videoControl;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *durationTimer;
@property (nonatomic, assign) BOOL playbackDurationSet;
@end


@implementation ABCVidepPlayerController

- (void)dealloc
{
    [self cancelObserver];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor blackColor];
        self.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:self.videoControl];
        [self configObserver];
        [self configControlAction];
    }
    return self;
}

#pragma mark - Override Method

- (void)setContentURL:(NSURL *)contentURL
{
    [self stop];
    [super setContentURL:contentURL];
}

#pragma mark - Publick Method

- (void)showInWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    [keyWindow addSubview:self.view];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)dismiss
{
    [self stopDurationTimer];
    [self stop];
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.dimissCompleteBlock) {
            self.dimissCompleteBlock();
        }
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)startPlay {
    [self stop];
    self.playbackDurationSet = YES;
    if (_startTime) {
        [self setInitialPlaybackTime:_startTime];
        [self play];
        self.playbackDurationSet = NO;
    }
    [self play];
}

#pragma mark - Private Method

- (void)configObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
}

- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configControlAction
{
    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];
}

#pragma mark - Notification
- (void)onMPMoviePlayerPlaybackStateDidChangeNotification:(NSNotification *)notification
{
    MPMoviePlayerController* player = (MPMoviePlayerController*)notification.object;
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        if (!self.playbackDurationSet) {
            [player setCurrentPlaybackTime:player.initialPlaybackTime];
            self.playbackDurationSet = YES;
        }
        [self startDurationTimer];
        [self.videoControl playingVideo];
        [self.videoControl autoFadeOutControlBar];
    } else {
        [self stopDurationTimer];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
            [self.videoControl animateShow];
            [self.videoControl stopVideo];
        }
    }
}

- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    if (self.loadState & MPMovieLoadStateStalled) {
        [self.videoControl setActivityIndicatorViewAnimation:YES];
    }
}

- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    [self.videoControl playingVideo];
}

- (void)onMPMovieDurationAvailableNotification
{
    [self setProgressSliderMaxMinValues];
}

#pragma mark - ABCVideoPlayerControlViewDelegate

- (void)didTapPlayerControlViewPlayButton {
    [self play];
}

- (void)didTapPlayerControlViewPauseButton {
    [self pause];
}

- (void)didTapPlayerControlViewCloseButton {
    [self dismiss];
}

- (void)didTapPlayerControlViewFullScreenButton {
    if (self.isFullscreenMode) {
        return;
    }
    self.originFrame = self.view.frame;
    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);;
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = frame;
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
    }];
}

- (void)didTapPlayerControlViewShrinkScreenButton {
    if (!self.isFullscreenMode) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
    } completion:^(BOOL finished) {
        self.isFullscreenMode = NO;
    }];
}

- (void)didChangePlayerControlViewProgressSliderValue:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)didTouchPlayerControlViewProgressSlide:(UISlider *)slider State:(UIControlEvents)state {
    if (state == UIControlEventTouchDown) {
        [self pause];
        [self.videoControl cancelAutoFadeOutControlBar];
    }else if (state == UIControlEventTouchUpInside || state == UIControlEventTouchUpOutside) {
        [self setCurrentPlaybackTime:floor(slider.value)];
        [self play];
        [self.videoControl autoFadeOutControlBar];
    }
}

- (void)didDoubleTapPlayerControlView:(BOOL)isStop {
    if (isStop) {
        [self pause];
    }else {
        [self play];
    }
}

#pragma mark - Private Method
- (void)monitorVideoPlayback
{
    double currentTime = floor(self.currentPlaybackTime);
    double totalTime = floor(self.duration);
    [self setTimeLabelValues:currentTime totalTime:totalTime];
    [self.videoControl setProgressSliderCurrentPlayValue:currentTime];
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];

    [self.videoControl setTimeLabelText:[NSString stringWithFormat:@"%@/%@",timeElapsedString,timeRmainingString]];
}

- (void)startDurationTimer
{
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer
{
    [self.durationTimer invalidate];
}

- (void)fadeDismissControl
{
    [self.videoControl animateHide];
}

- (void)setProgressSliderMaxMinValues {
    CGFloat duration = self.duration;
    [self.videoControl setProgressSliderDuringPlayValue:floorf(duration)];
}

#pragma mark - Property

- (ABCVideoPlayerControlView *)videoControl
{
    if (!_videoControl) {
        _videoControl = [[ABCVideoPlayerControlView alloc] initWithFrame:self.view.frame];
        _videoControl.delegate = self;
    }
    return _videoControl;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.videoControl setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.videoControl setNeedsLayout];
    [self.videoControl layoutIfNeeded];
}

@end
