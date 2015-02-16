//
//  NSDictionary+ObjectForKeyNotNull.h
//  CfA Projects to CSV
//
//  Created by Jay Whitsitt on 2/16/15.
//  Copyright (c) 2015 Jay Whitsitt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ObjectForKeyNotNull)

/** This was taken from http://stackoverflow.com/questions/5739067/how-to-map-json-objects-to-objective-c-classes */
- (id)objectForKeyNotNull:(id)key;

@end
