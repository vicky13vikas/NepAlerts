//
//  Area.h
//  Nepalerts
//
//  Created by Vikas Kumar on 10/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface Area : NSObject

@property (nonatomic, assign) NSUInteger areaID;
@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) City *city;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
