//
//  ABCMosiacView.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCMosiacDataView.h"

@class ABCMosiacView;

@protocol ABCMosiacViewDataSource <NSObject>

-(NSArray *)mosaicElements;

@end

@protocol ABCMosiacViewDelegate <NSObject>

- (void)mosaicViewDidTap:(ABCMosiacDataView *)dataView;

- (void)mosaicViewHeaderRefresh:(ABCMosiacView *)dataView;

- (void)mosaicViewFooterRefresh:(ABCMosiacView *)dataView;

@end

@interface ABCMosiacView : UIView

@property (nonatomic, weak) id<ABCMosiacViewDelegate> delegate;

@property (nonatomic, weak) id<ABCMosiacViewDataSource> dataSource;

- (void)refresh;

@end
