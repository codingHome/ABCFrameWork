//
//  ABCVideoPlayerControlView.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/10.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABCVideoPlayerControlView;

@protocol ABCVideoPlayerControlViewDelegate <NSObject>

- (void)didTapPlayerControlViewPlayButton;

- (void)didTapPlayerControlViewPauseButton;

- (void)didTapPlayerControlViewCloseButton;

- (void)didTapPlayerControlViewFullScreenButton;

- (void)didTapPlayerControlViewShrinkScreenButton;

- (void)didChangePlayerControlViewProgressSliderValue:(UISlider *)slider;

- (void)didTouchPlayerControlViewProgressSlide:(UISlider *)slider State:(UIControlEvents)state;

- (void)didDoubleTapPlayerControlView:(BOOL)isStop;

@end

@interface ABCVideoPlayerControlView : UIView

@property (nonatomic, weak) id<ABCVideoPlayerControlViewDelegate>delegate;

- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;
- (void)playingVideo;
- (void)stopVideo;

- (void)setProgressSliderCurrentPlayValue:(double)value;
- (void)setProgressSliderDuringPlayValue:(double)value;
- (void)setTimeLabelText:(NSString *)time;
- (void)setActivityIndicatorViewAnimation:(BOOL)isOn;

@end
