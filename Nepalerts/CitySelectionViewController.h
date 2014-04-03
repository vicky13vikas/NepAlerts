//
//  CitySelectionViewController.h
//  Nepalerts
//
//  Created by Vikas Kumar on 01/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectionViewController : UIViewController

@property (nonatomic, strong) NSString *selectedState;
@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) NSArray *areasList;

@end
