//
//  ABCImageLoader.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCImageLoader.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+RJLoader.h"

@interface ABCImageLoader ()

@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)UIImage *placeHolderImage;

@end

@implementation ABCImageLoader

- (instancetype)initWithFrame:(CGRect)frame Url:(NSString *)url placeHolder:(NSString *)placeHolder tintColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        _url = [url copy];
        _placeHolderImage = [UIImage imageNamed:placeHolder];
        [self startLoaderWithTintColor:color];
        [self loadImage];
    }
    return self;
}


- (void)loadImage {
    [self sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:_placeHolderImage options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [self updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self reveal];
    }];
}

@end
