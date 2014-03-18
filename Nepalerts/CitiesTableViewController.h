//
//  CitiesTableViewController.h
//  Nepalerts
//
//  Created by Vikas Kumar on 10/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@protocol CityDelegate <NSObject>
- (void)citySlected:(City*)city;

@end


@interface CitiesTableViewController : UITableViewController

@property (nonatomic, strong) id<CityDelegate> delegate;
@property (nonatomic, strong) State *state;

@end
