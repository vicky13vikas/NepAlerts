//
//  City.h
//  Nepalerts
//
//  Created by Vikas Kumar on 10/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "State.h"

@interface City : NSObject

@property (nonatomic, assign) NSUInteger cityID;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) State *state;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
