//
//  ABCPhotoAlbum.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCPhotoAlbum.h"

//* 相册模式判断
#define SET_PICKER_SOURCE_TYPE(__picker, __sourceType)                  \
if ([UIImagePickerController isSourceTypeAvailable:__sourceType]) {     \
__picker.sourceType = __sourceType;                                     \
}                                                                       \
else{                                                                   \
NSDictionary *dic = @{@"error":@"hardware error"};                      \
[self.delegate getPhotoFailedInfo:dic];                                 \
return;                                                                 \
}

@interface ABCPhotoAlbum ()

@property (nonatomic, strong) UIViewController *vc;

@end

@implementation ABCPhotoAlbum

/**
 *  单例方法
 *
 *  @return 实例变量
 */
+ (ABCPhotoAlbum *)sharedPhotoAlbum {
    static dispatch_once_t onceToken;
    static ABCPhotoAlbum *sharedPhotoAlbum;
    dispatch_once(&onceToken, ^{
        sharedPhotoAlbum = [[self alloc] init];
    });
    return sharedPhotoAlbum;
}

- (void)getPhotoAlbumInSuperViewController:(UIViewController*)viewController {
    self.delegate = (id)viewController;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"相机",@"相册", nil];
    [actionSheet showInView:viewController.view];
    
    _vc = viewController;
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    switch (buttonIndex) {
        case 0:
            SET_PICKER_SOURCE_TYPE(imagePicker, UIImagePickerControllerSourceTypeCamera);
            break;
        case 1:
            SET_PICKER_SOURCE_TYPE(imagePicker, UIImagePickerControllerSourceTypePhotoLibrary);
            break;
        default:
            return;
    }
    [_vc presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    // 原图
    UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    // 编辑图
    UIImage *editedImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    [self.delegate getPhotoSucceedOriginalImage:originalImage editedImage:editedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
