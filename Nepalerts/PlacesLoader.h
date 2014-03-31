//
//  PlacesLoader.h
//  Nepalerts
//
//  Created by Vikas Kumar on 30/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

typedef void (^SuccessHandler)(NSDictionary *responseDict);
typedef void (^ErrorHandler)(NSError *error);

@class Place;

@interface PlacesLoader : NSObject

+ (PlacesLoader *)sharedInstance;
- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;
- (void)loadDetailInformation:(Place *)location successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

@end
