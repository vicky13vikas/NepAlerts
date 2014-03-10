//
//  City.m
//  Nepalerts
//
//  Created by Vikas Kumar on 10/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.cityID = (NSUInteger)[[attributes valueForKeyPath:@"id"] integerValue];
    self.cityName = [attributes valueForKeyPath:@"name"];
        
    return self;
}

@end
