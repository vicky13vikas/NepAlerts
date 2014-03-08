//
//  AFAppClient.h
//  Nepalerts
//
//  Created by Vikas kumar on 08/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFAppClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
