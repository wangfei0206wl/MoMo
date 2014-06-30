//
//  NSMutableDictionary+NullObject.h
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NullObject)

- (void)setNullObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
