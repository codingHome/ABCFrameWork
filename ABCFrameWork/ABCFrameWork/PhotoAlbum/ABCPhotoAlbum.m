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

@property (nonatomic, strong) UIColor *backGroundColor;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) BOOL isBlur;

@end

@implementation ABCPhotoAlbum

- (instancetype)initWithActionSheetBackgroundColor:(UIColor *)backColor textColor:(UIColor *)textColor{
    self = [super init];
    if (self) {
        _backGroundColor = backColor;
        _textColor = textColor;
    }
    return self;
}

- (void)getPhotoAlbumInSuperViewController:(UIViewController*)viewController {
    self.delegate = (id)viewController;
    _vc = viewController;
    
    IBActionSheet *customIBAS = [[IBActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"相机",@"相册", nil];
    
    [customIBAS setButtonBackgroundColor:_backGroundColor];
    [customIBAS setButtonTextColor:_textColor];
    customIBAS.buttonResponse = IBActionSheetButtonResponseReversesColorsOnPress;
    
    [customIBAS showInView:viewController.view];
}

#pragma mark -
#pragma mark IBActionSheet/UIActionSheet Delegate Method
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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
