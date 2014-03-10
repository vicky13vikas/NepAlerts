//
//  Area.m
//  Nepalerts
//
//  Created by Vikas Kumar on 10/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "Area.h"

@implementation Area

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.areaID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.areaName = [attributes valueForKeyPath:@"area"];
    
    return self;
}

@end
