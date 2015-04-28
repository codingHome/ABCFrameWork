//
//  ABCRequestModel.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/28.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCRequestModel.h"
#import <objc/runtime.h>

@implementation ABCRequestModel

- (NSString *)operationURL {
    NSMutableString *url = [NSMutableString string];
    NSArray *classProperty = [self classPropertyList];
    NSDictionary *instancePropertiesList = [self instancePropertiesList];
    
    for (NSString *key in classProperty) {
        if (url.length != 0) {
            [url appendString:@"&"];
        }
        NSString * value = [instancePropertiesList objectForKey:key];
        [url appendString:key];
        [url appendString:@"="];
        [url appendString:value];
    }
    return url;
}

#pragma mark -
#pragma mark Private Method
- (NSDictionary *)instancePropertiesList {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue){
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

- (NSMutableArray *)classPropertyList {
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    free(properties);
    return props;
}

@end
