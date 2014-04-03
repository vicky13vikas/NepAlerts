//
//  AreasTableViewController.h
//  Nepalerts
//
//  Created by Vikas Kumar on 10/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Area.h"
#import "City.h"

@protocol AreaDelegate <NSObject>
- (void)areaSlected:(NSString*)area;

@end

@interface AreasTableViewController : UITableViewController

@property (nonatomic, strong) id<AreaDelegate> delegate;
@property (nonatomic, strong) City *city;

@property (nonatomic, strong) NSArray *areaList;

@end
