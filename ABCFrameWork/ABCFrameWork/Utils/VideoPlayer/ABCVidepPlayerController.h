//
//  ABCVidepPlayerController.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/10.
//  Copyright © 2015年 Robert. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface ABCVidepPlayerController : MPMoviePlayerController

@property (nonatomic, copy)void(^dimissCompleteBlock)(void);

@property (nonatomic, assign)double startTime;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
- (void)showInWindow;
- (void)dismiss;

- (void)startPlay;

@end
