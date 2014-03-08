//
//  AFAppClient.m
//  Nepalerts
//
//  Created by Vikas kumar on 08/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "AFAppClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"http://210.212.195.100:8088/";

@implementation AFAppClient

+ (instancetype)sharedClient {
    static AFAppClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
    });
    
    return _sharedClient;
}


@end
