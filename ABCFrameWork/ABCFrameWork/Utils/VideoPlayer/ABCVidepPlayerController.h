//
//  ABCVidepPlayerController.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/10.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface ABCVidepPlayerController : MPMoviePlayerController

@property (nonatomic, copy)void(^dimissCompleteBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame;
- (void)showInWindow;
- (void)dismiss;

@end
