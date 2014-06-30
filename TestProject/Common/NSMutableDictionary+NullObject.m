//
//  NSMutableDictionary+NullObject.m
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "NSMutableDictionary+NullObject.h"

@implementation NSMutableDictionary (NullObject)

- (void)setNullObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (anObject == nil) {
        [self setObject:@"" forKey:aKey];
    }
    else {
        [self setObject:anObject forKey:aKey];
    }
}

@end
