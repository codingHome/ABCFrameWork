//
//  ABCMosiacDataModel.m
//  ABCFrameWork
//
//  Created by Robert on 15/12/11.
//  Copyright © 2015年 NationSky. All rights reserved.
//

#import "ABCMosiacDataModel.h"

@implementation ABCMosiacDataModel

-(id)initWithDictionary:(NSDictionary *)aDict{
    self = [self init];
    if (self){
        self.imageUrl = [aDict objectForKey:@"imageUrl"];
        self.imageSize = [[aDict objectForKey:@"imageSize"] integerValue];
        self.title = [aDict objectForKey:@"title"];
    }
    return self;
}

@end
