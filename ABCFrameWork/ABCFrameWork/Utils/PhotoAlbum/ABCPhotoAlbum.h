//
//  ABCPhotoAlbum.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBActionSheet.h"

@protocol ABCPhotoAlbumDelegate <NSObject>

/**
 *  获取照片成功回调
 *
 *  @param originalImage 原始图片
 *  @param editedImage   编辑后图片
 */
- (void)getPhotoSucceedOriginalImage:(UIImage *)originalImage editedImage:(UIImage *)editedImage;

/**
 *  获取图片失败回调
 *
 *  @param info 回调返回错误信息
 */
- (void)getPhotoFailedInfo:(NSDictionary *)info;

@end

@interface ABCPhotoAlbum : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,IBActionSheetDelegate>

@property (nonatomic, weak) id<ABCPhotoAlbumDelegate>delegate;

/**
 *  初始化方法
 *
 *  @param backColor 背景颜色
 *  @param textColor 文字颜色
 *
 *  @return 实例变量
 */
- (instancetype)initWithActionSheetBackgroundColor:(UIColor *)backColor textColor:(UIColor *)textColor;

/**
 *  获取图片库
 *
 *  @param viewController 图片库父视图
 */
- (void)getPhotoAlbumInSuperViewController:(UIViewController*)viewController;

@end
