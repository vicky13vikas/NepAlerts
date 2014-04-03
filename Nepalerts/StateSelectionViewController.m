//
//  StateSelectionViewController.m
//  Nepalerts
//
//  Created by Vikas Kumar on 01/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "StateSelectionViewController.h"
#import "AFAppClient.h"
#import "SVProgressHUD.h"
#import "PlacesLoader.h"
#import "Place.h"
#import "StateTableViewController.h"
#import "CitySelectionViewController.h"

@import CoreLocation;

#define API_KEY @"AIzaSyAs2YcG1A5CyS9jr00mxubl_LynXa80w8Q"

NSString * const kNameKey = @"name";
NSString * const kReferenceKey = @"reference";
NSString * const kAddressKey = @"vicinity";
NSString * const kLatiudeKeypath = @"geometry.location.lat";
NSString * const kLongitudeKeypath = @"geometry.location.lng";

@interface StateSelectionViewController ()<CLLocationManagerDelegate, StateDelegate>
{
    NSMutableArray *_states;
    NSMutableArray *_cities;
    NSMutableArray *_areas;
    
    NSMutableArray *_placesList;
    NSMutableArray *_addressDetailList;
    
    NSInteger _totalRequests;
    NSInteger _totalResponses;
}

@property (weak, nonatomic) IBOutlet UITextField *tfState;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D currentUserCoordinate;

@end

@implementation StateSelectionViewController

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
    
    _placesList = [[NSMutableArray alloc] init];
    _addressDetailList = [[NSMutableArray alloc] init];
    _states = [[NSMutableArray alloc] init];
    _cities = [[NSMutableArray alloc] init];
    _areas = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_states.count == 0 || _cities.count == 0 || _areas.count == 0)
    {
        [self startUpdatingCurrentLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (_tfState.text.length <= 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a state first" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return NO;
    }
    else
        return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CitySelectionViewController *vc = (CitySelectionViewController*)[segue destinationViewController];
    vc.selectedState = _tfState.text;
    vc.areasList = _areas;
    vc.cityList = _cities;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    StateTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StateTableViewController"];
    vc.delegate = self;
    vc.statesList = _states;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

-(void)stateSlected:(NSString *)state
{
    _tfState.text = state;
}

#pragma mark - CLLocationManagerDelegate

- (void)startUpdatingCurrentLocation
{
    SVProgressHUD *progressHud = [SVProgressHUD appearance];
    progressHud.hudBackgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [SVProgressHUD showWithStatus:@"Fetching Location..." maskType:SVProgressHUDMaskTypeClear];
    
    // if location services are restricted do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        return;
    }
    
    // if locationManager does not currently exist, create it
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 10.0f; // we don't need to be any more accurate than 10m
    }
    
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingCurrentLocation
{
    [SVProgressHUD dismiss];
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30)
    {
        return;
    }
    _currentUserCoordinate = [newLocation coordinate];
    [self loadNearByPlaces];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error Loading location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    _currentUserCoordinate = kCLLocationCoordinate2DInvalid;

}


#pragma - google places -

- (void)loadNearByPlaces
{
    CLLocationCoordinate2D coord = _currentUserCoordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    [[PlacesLoader sharedInstance] loadPOIsForLocation:location radius:1000 successHanlder:^(NSDictionary *response) {
        if([[response objectForKey:@"status"] isEqualToString:@"OK"])
        {
            id places = [response objectForKey:@"results"];
            NSMutableArray *temp = [NSMutableArray array];
            
            if([places isKindOfClass:[NSArray class]])
            {
                for(NSDictionary *resultsDict in places)
                {
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:[[resultsDict valueForKeyPath:kLatiudeKeypath] floatValue] longitude:[[resultsDict valueForKeyPath:kLongitudeKeypath] floatValue]];
                    Place *currentPlace = [[Place alloc] initWithLocation:location reference:[resultsDict objectForKey:kReferenceKey] name:[resultsDict objectForKey:kNameKey] address:[resultsDict objectForKey:kAddressKey]];
                    [temp addObject:currentPlace];
                }
                _placesList = [temp copy];
                [self getPlacesDetail];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
            [self loadNearByPlaces];
        }
    } errorHandler:^(NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"Error: %@", error);
    }];
}

-(void)getPlacesDetail
{
    [_addressDetailList removeAllObjects];
    _totalRequests = _placesList.count;
    _totalResponses = 0;
    for(Place *place in _placesList)
    {
        [self getPlaceDetailForPlace:place];
    }
}

-(void)getPlaceDetailForPlace:(Place*)place
{
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@", place.reference, API_KEY];
    
    [client GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _totalResponses++;
        [_addressDetailList addObject:[[responseObject valueForKey:@"result"] valueForKey:@"address_components"]];
        [self checkIfRequestsCompleted];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _totalResponses++;
        NSLog(@"%@", error);
        [self checkIfRequestsCompleted];
    }];
}

-(void) checkIfRequestsCompleted
{
    if(_totalResponses == _totalRequests)
    {
        [SVProgressHUD dismiss];
//        [self stopUpdatingCurrentLocation];
        [self parseAllAddress];
        
        _tfState.text = _states[0];
    }
}

-(void)parseAllAddress
{
    for(NSArray *array in _addressDetailList)
    {
        for(id item in array)
        {
            NSArray *types = [item valueForKey:@"types"];
            
            //Parsing State
            if([types containsObject:@"administrative_area_level_1"])
            {
                if(![_states containsObject:[item valueForKey:@"long_name"]])
                    [_states addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"administrative_area_level_2"])
            {
                if(![_states containsObject:[item valueForKey:@"long_name"]])
                    [_states addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"administrative_area_level_3"])
            {
                if(![_states containsObject:[item valueForKey:@"long_name"]])
                    [_states addObject:[item valueForKey:@"long_name"]];
            }
            
            
            //Parsing Cities
            if([types containsObject:@"locality"])
            {
                if(![_cities containsObject:[item valueForKey:@"long_name"]])
                    [_cities addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"sublocality"])
            {
                if(![_cities containsObject:[item valueForKey:@"long_name"]])
                    [_cities addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"sublocality_level_4"])
            {
                if(![_cities containsObject:[item valueForKey:@"long_name"]])
                    [_cities addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"sublocality_level_5"])
            {
                if(![_cities containsObject:[item valueForKey:@"long_name"]])
                    [_cities addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"sublocality_level_3"])
            {
                if(![_cities containsObject:[item valueForKey:@"long_name"]])
                    [_cities addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"sublocality_level_2"])
            {
                if(![_cities containsObject:[item valueForKey:@"long_name"]])
                    [_cities addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"sublocality_level_2"])
            {
                if(![_cities containsObject:[item valueForKey:@"long_name"]])
                    [_cities addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"sublocality_level_1"])
            {
                if(![_cities containsObject:[item valueForKey:@"long_name"]])
                    [_cities addObject:[item valueForKey:@"long_name"]];
            }
            
            //Parsing Areas
            if([types containsObject:@"route"])
            {
                if(![_areas containsObject:[item valueForKey:@"long_name"]])
                    [_areas addObject:[item valueForKey:@"long_name"]];
            }
            else if([types containsObject:@"street_address"])
            {
                if(![_areas containsObject:[item valueForKey:@"long_name"]])
                    [_areas addObject:[item valueForKey:@"long_name"]];
            }
        }
    }
}


@end
