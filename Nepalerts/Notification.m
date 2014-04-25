//
//  Notification.m
//  Nepalerts
//
//  Created by Vikas Kumar on 25/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "Notification.h"

@implementation Notification

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.notificationID = [NSString stringWithFormat:@"%long",(long)[attributes valueForKeyPath:@"Id"]];
    self.message        = [attributes valueForKeyPath:@"PushContent"];
    self.date           = [self getdateStringFromTicks:[NSString stringWithFormat:@"%@",[attributes valueForKeyPath:@"DateTimeInTicks"]]];
    
    return self;
}

-(NSString*)getdateStringFromTicks:(NSString*)ticks
{
    NSDate *date = [self ticksToDate:ticks];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"hh:mm a EEE, dd MMM yyyy"];
    
    return [format stringFromDate:date];
}

-(NSDate *) ticksToDate:(NSString *) ticks
{
    double tickFactor = 10000000;
    double ticksDoubleValue = [ticks doubleValue];
    double seconds = ((ticksDoubleValue - 621355968000000000)/ tickFactor);
    NSDate *returnDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    return returnDate;
}
@end
