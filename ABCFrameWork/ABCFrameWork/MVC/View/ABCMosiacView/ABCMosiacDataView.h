//
//  ABCMosiacDataView.h
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABCMosiacDataModel.h"

@class ABCMosiacDataView;

@protocol ABCMosiacDataViewDelegate <NSObject>

- (void)didTapDataView:(ABCMosiacDataView *)dataView;

@end

@interface ABCMosiacDataView : UIView

/**
 *  数据源
 */
@property (nonatomic, strong)ABCMosiacDataModel *dataModel;

@property (nonatomic, weak)id<ABCMosiacDataViewDelegate> delegate;

@end
