//
//  RegisterViewController.m
//  Nepalerts
//
//  Created by Vikas kumar on 07/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFAppClient.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "StateTableViewController.h"
#import "CitiesTableViewController.h"
#import "AreasTableViewController.h"
#import "City.h"
#import "Area.h"

#import "PlacesLoader.h"
#import "Place.h"

#define API_KEY @"AIzaSyAs2YcG1A5CyS9jr00mxubl_LynXa80w8Q"


NSString * const kNameKey = @"name";
NSString * const kReferenceKey = @"reference";
NSString * const kAddressKey = @"vicinity";
NSString * const kLatiudeKeypath = @"geometry.location.lat";
NSString * const kLongitudeKeypath = @"geometry.location.lng";

@import CoreLocation;

@interface RegisterViewController ()<StateDelegate, CityDelegate, AreaDelegate>
{
    BOOL isKeyboardVisible;
    NSString * _selectedState;
    NSString * _selectedCity;
    NSString * _selectedArea;
    NSMutableArray *_placesList;
    NSMutableArray *_addressDetailList;
    NSInteger _totalRequests;
    NSInteger _totalResponses;
    NSMutableArray *_states;
    NSMutableArray *_cities;
    NSMutableArray *_areas;
}

@property (weak, nonatomic) IBOutlet UITextField *tfState;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UITextField *tfArea;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D currentUserCoordinate;

@end

@implementation RegisterViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (_states.count == 0 || _cities.count == 0 || _areas.count == 0)
    {
        [self startUpdatingCurrentLocation];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyBoardWillShow:(NSNotification*)notification
{
    if(!isKeyboardVisible)
    {
        isKeyboardVisible = YES;
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        
        CGRect frame = _scrollView.frame;
        frame.size.height = frame.size.height - keyboardFrameBeginRect.size.height;
        _scrollView.frame = frame;
    }
}

-(void)keyBoardWillHide:(NSNotification*)notification
{
    if(isKeyboardVisible)
    {
        isKeyboardVisible = NO;
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        
        CGRect frame = _scrollView.frame;
        frame.size.height = frame.size.height + keyboardFrameBeginRect.size.height;
        _scrollView.frame = frame;
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDictionary *)getParameters
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_TOKEN];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                _tfState.text, @"State",
                                _tfCity.text, @"City",
                                _tfArea.text, @"Area",
                                deviceToken, @"RegId",
                                @"iOS", @"OS",
                                nil];
    
    return parameters;
}

- (IBAction)submitTapped:(id)sender
{
    SVProgressHUD *progressHud = [SVProgressHUD appearance];
    progressHud.hudBackgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeClear];
    
    [[AFAppClient sharedClient] POST:@"RegistrationService.svc/StartRegister"
                          parameters:[self getParameters]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [SVProgressHUD dismiss];
                                 NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

                                 NSLog(@"%@", string);
                                 
                                 if(![string isEqualToString:@"-1"])
                                 {
                                     [[[UIAlertView alloc] initWithTitle:@"Nep Alerts" message:@"Submitted Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                 }
                                 else
                                 {
                                     [[[UIAlertView alloc] initWithTitle:@"Nep Alerts" message:@"Request Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                 }
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [SVProgressHUD dismiss];
                                 NSLog(@"%@", error);
                             }];
}

-(void)dismissKeyboard
{
    [_tfCity resignFirstResponder];
    [_tfArea resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:_tfState])
    {
        StateTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StateTableViewController"];
        vc.delegate = self;
        vc.statesList = _states;
        [self.navigationController pushViewController:vc animated:YES];
        [self dismissKeyboard];
        return NO;
    }
    else if([textField isEqual:_tfCity])
    {
        if(!_selectedState)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a state first" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        else
        {
            CitiesTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CitiesTableViewController"];
            vc.delegate = self;
            vc.citiesList = _cities;
            [self.navigationController pushViewController:vc animated:YES];
            [self dismissKeyboard];
            return NO;
        }
    }
    else if([textField isEqual:_tfArea])
    {
        if(!_selectedCity)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a city first" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        else
        {
            AreasTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AreasTableViewController"];
            vc.delegate = self;
            vc.areaList = _areas;
            [self.navigationController pushViewController:vc animated:YES];
            [self dismissKeyboard];
        }
        return NO;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:_tfState])
    {
        [_tfCity becomeFirstResponder];
    }
    else if([textField isEqual:_tfCity])
    {
        [_tfArea becomeFirstResponder];
    }
    else if([textField isEqual:_tfArea])
    {

    }
    return YES;
}

- (void)citySlected:(NSString*)city
{
    _selectedArea = nil;
    _tfArea.text = nil;
    _tfCity.text = city;
    _selectedCity = city;
}

-(void) areaSlected:(NSString *)area forCity:(NSString *)city
{
    _tfArea.text = area;
    _selectedArea = area;
}

-(void)stateSlected:(NSString *)state
{
    _tfState.text = state;
    _selectedState = state;
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
        _locationManager.purpose = @"This may be used to obtain your reverse geocoded address";
    }
    
    [_locationManager startUpdatingLocation];
    
    //    [self showCurrentLocationSpinner:YES];
}

- (void)stopUpdatingCurrentLocation
{
    [SVProgressHUD dismiss];

    [_locationManager stopUpdatingLocation];
    
    //    [self showCurrentLocationSpinner:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    // if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30)
    {
        return;
    }
    
    _currentUserCoordinate = [newLocation coordinate];
    
    [self loadNearByPlaces];
//    [self performCoordinateGeocode];
    //    [self stopUpdatingCurrentLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [SVProgressHUD dismiss];

    NSLog(@"%@", error);
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error Loading location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

    // stop updating
    //    [self stopUpdatingCurrentLocation];
    
    // since we got an error, set selected location to invalid location
    _currentUserCoordinate = kCLLocationCoordinate2DInvalid;
    
    // show the error alert
    //    UIAlertView *alert = [[UIAlertView alloc] init];
    //    alert.title = @"Error updating location";
    //    alert.message = [error localizedDescription];
    //    [alert addButtonWithTitle:@"OK"];
    //    [alert show];
}

- (void)performCoordinateGeocode
{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocationCoordinate2D coord = _currentUserCoordinate;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        [SVProgressHUD dismiss];
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            //            [self displayError:error];
            return;
        }
        NSLog(@"Received placemarks: %@", placemarks);
        [self displayPlacemarks:placemarks];
    }];
}

-(void)displayPlacemarks:(NSArray*)placemarks
{
    CLPlacemark *placeMarkToShow = placemarks[0];
    
    if(placeMarkToShow.administrativeArea.length > 0)
    {
        _tfState.text = placeMarkToShow.administrativeArea;
    }
    if(placeMarkToShow.locality.length > 0)
    {
        _tfCity.text = placeMarkToShow.locality;
    }
    else
    {
        _tfCity.text = placeMarkToShow.thoroughfare;
    }
    if(placeMarkToShow.thoroughfare.length > 0)
    {
        _tfArea.text = placeMarkToShow.thoroughfare;
    }
    
//    [self stopUpdatingCurrentLocation];
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
            [SVProgressHUD dismiss];
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
        [self stopUpdatingCurrentLocation];
        [self parseAllAddress];
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
