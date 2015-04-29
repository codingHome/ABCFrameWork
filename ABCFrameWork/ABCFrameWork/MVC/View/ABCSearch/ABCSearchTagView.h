//
//  ABCSearchTagView.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABCSearchTagViewDelegate <NSObject>

- (void)theTagsContent:(NSString *)tagsContent;

@end

@interface ABCSearchTagView : UIView

@property (nonatomic, assign) id<ABCSearchTagViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame tagsArrar:(NSArray *)array;

@end
