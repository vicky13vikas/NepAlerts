//
//  State.m
//  Nepalerts
//
//  Created by Vikas kumar on 18/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "State.h"

@implementation State

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.stateID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.stateName = [attributes valueForKeyPath:@"state"];
    
    return self;
}

@end
