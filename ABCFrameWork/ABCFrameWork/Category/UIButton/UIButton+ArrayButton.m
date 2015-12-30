//
//  UIButton+ArrayButton.m
//  RYSearch
//
//  Created by Robert on 15/4/24.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import "UIButton+ArrayButton.h"

static const int TextFount = 13;
static const int ButtonHeight = 26;
int Left = 10;
int Top = 50;

@implementation UIButton (ArrayButton)

+ (NSArray *)ButtonWithArray:(NSArray *)array Gap:(NSUInteger)gap {
    NSMutableArray *buttonArray = [NSMutableArray array];
    
    NSUInteger totalX = 0;
    NSUInteger totalY = 0;
    for (int i = 0; i < array.count; i++) {
        NSString *title = array[i];
        UIButton *button = [[self alloc] buttonSetting];
        [button setTitle:title forState:UIControlStateNormal];
        button.tag = i;
        
        button.frame = CGRectMake(0, 0, ABC_SCREEN_WIDTH, ButtonHeight);
        [button sizeToFit];
        
        NSUInteger ButtonX = Left + totalX;
        NSUInteger ButtonY = Top + totalY;
        
        NSUInteger ButtonWidth = button.bounds.size.width;
        totalX += ButtonWidth + gap;
        
        if (totalX >= ABC_SCREEN_WIDTH) {
            totalX = ButtonWidth + gap;
            ButtonX = Left;
            totalY += ButtonHeight + 5;
            ButtonY = totalY + Top;
        }
        
        button.frame = CGRectMake(ButtonX, ButtonY, ButtonWidth, ButtonHeight);
        
        [buttonArray addObject:button];
    }
    return buttonArray;
}

//button基本设置
- (UIButton *)buttonSetting {
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    button.titleLabel.font = [UIFont systemFontOfSize:TextFount];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 5;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1;
    return button;
}

@end
