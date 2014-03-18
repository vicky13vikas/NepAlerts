//
//  State.h
//  Nepalerts
//
//  Created by Vikas kumar on 18/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface State : NSObject

@property (nonatomic, assign) NSUInteger stateID;
@property (nonatomic, strong) NSString *stateName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
