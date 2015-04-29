//
//  ABCSearchTagView.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCSearchTagView.h"
#import "UIButton+ArrayButton.h"

@interface ABCSearchTagView ()

@property (nonatomic, strong) NSArray *tagsArray;

@end

@implementation ABCSearchTagView

-(instancetype)initWithFrame:(CGRect)frame tagsArrar:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.tagsArray = array;
        [self addTitleView];
        [self addTagsButton];
    }
    return self;
}
- (void)addTitleView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 50, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.text = @"检索";
    [self addSubview:label];
}
- (void)addTagsButton {
    NSArray *buttonArray = [UIButton ButtonWithArray:_tagsArray Gap:10];
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = buttonArray[i];
        [self addSubview:button];
        button.alpha = 0.0f;
        [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            button.alpha = 1.0f;
        } completion:nil];
        [button addTarget:self action:@selector(buttonTagsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)buttonTagsAction:(UIButton *)button {
    NSInteger index = button.tag;
    [self theTagsContent:self.tagsArray[index]];
}

- (void)theTagsContent:(NSString *)tagsContent {
    if ([self.delegate respondsToSelector:@selector(theTagsContent:)])
    {
        [self.delegate theTagsContent:tagsContent];
    }
}

@end
