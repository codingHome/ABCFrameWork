//
//  ABCSearchDelegate.h
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABCSearchTagView.h"

@interface ABCSearchDelegate : NSObject <UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate,ABCSearchTagViewDelegate>

/**
 *  单例方法
 */
+ (ABCSearchDelegate *)sharedDelegate;

@end
