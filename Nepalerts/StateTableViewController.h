//
//  StateTableViewController.h
//  Nepalerts
//
//  Created by Vikas kumar on 18/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "State.h"

@protocol StateDelegate <NSObject>
- (void)stateSlected:(State*)state;

@end

@interface StateTableViewController : UITableViewController

@property (nonatomic, strong) id<StateDelegate> delegate;

@end
