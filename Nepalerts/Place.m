//
//  Place.m
//  Nepalerts
//
//  Created by Vikas Kumar on 30/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "Place.h"

@implementation Place

- (id)initWithLocation:(CLLocation *)location reference:(NSString *)reference name:(NSString *)name address:(NSString *)address {
	if((self = [super init])) {
		_location = location;
		_reference = [reference copy];
		_placeName = [name copy];
		_address = [address copy];
	}
	
	return self;
}

- (NSString *)infoText {
	return [NSString stringWithFormat:@"Name:%@\nAddress:%@\nPhone:%@\nWeb:%@", _placeName, _address, _phoneNumber, _website];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ Name:%@, location:%@", [super description], _placeName, _location];
}

@end