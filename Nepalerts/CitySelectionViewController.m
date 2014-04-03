//
//  CitySelectionViewController.m
//  Nepalerts
//
//  Created by Vikas Kumar on 01/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "CitySelectionViewController.h"
#import "CitiesTableViewController.h"
#import "AreaSelectionViewController.h"

@interface CitySelectionViewController ()<CityDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfCity;

@end

@implementation CitySelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _tfCity.text = _cityList[0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (_tfCity.text.length <= 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a state first" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
    else
        return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AreaSelectionViewController *vc = (AreaSelectionViewController*)[segue destinationViewController];
    vc.selectedState = _selectedState;
    vc.selectedCity = _tfCity.text;
    vc.areasList = _areasList;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CitiesTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CitiesTableViewController"];
    vc.delegate = self;
    vc.citiesList = _cityList;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

- (void)citySlected:(NSString*)city
{
    _tfCity.text = city;
}

@end
