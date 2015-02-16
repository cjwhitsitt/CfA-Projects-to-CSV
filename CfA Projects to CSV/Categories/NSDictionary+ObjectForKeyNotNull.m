//
//  NSDictionary+ObjectForKeyNotNull.m
//  CfA Projects to CSV
//
//  Created by Jay Whitsitt on 2/16/15.
//  Copyright (c) 2015 Jay Whitsitt. All rights reserved.
//

#import "NSDictionary+ObjectForKeyNotNull.h"

@implementation NSDictionary (ObjectForKeyNotNull)

- (id)objectForKeyNotNull:(NSString *)key {
    id object = [self objectForKey:key];
    if ((NSNull *)object == [NSNull null] || (__bridge CFNullRef)object == kCFNull)
        return nil;
    
    return object;
}

@end
