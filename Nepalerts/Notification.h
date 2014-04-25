//
//  Notification.h
//  Nepalerts
//
//  Created by Vikas Kumar on 25/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property(nonatomic, strong) NSString* message;
@property(nonatomic, strong) NSString* date;
@property(nonatomic, strong) NSString* notificationID;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
