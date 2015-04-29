//
//  ABCSearchTableCell.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCSearchTableCell.h"

@implementation ABCSearchTableCell

+ (instancetype)initViewFromXIB {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                          owner:nil
                                        options:nil] lastObject];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
