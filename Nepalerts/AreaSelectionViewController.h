//
//  AreaSelectionViewController.h
//  Nepalerts
//
//  Created by Vikas Kumar on 01/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaSelectionViewController : UIViewController

@property (nonatomic, strong) NSString *selectedState;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSArray *areasList;

@end
