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
#import "CitiesTableViewController.h"
#import "AreasTableViewController.h"
#import "City.h"
#import "Area.h"

@interface RegisterViewController ()<CityDelegate, AreaDelegate>
{
    BOOL isKeyboardVisible;
    City * _selectedCity;
    Area * _selectedArea;
}

@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UITextField *tfArea;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    NSMutableString *name  = [NSMutableString stringWithString:_tfFirstName.text];
    if(_tfLastName.text.length > 0)
    {
        [name appendString:@" "];
        [name appendString:_tfLastName.text];
    }
    
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_TOKEN];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                name, @"Name",
                                _tfCity.text, @"City",
                                _tfArea.text, @"Area",
                                deviceToken, @"RegId",
                                @"iOS", @"OsType",
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
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [SVProgressHUD dismiss];
                                 NSLog(@"%@", error);
                             }];
}

-(void)dismissKeyboard
{
    [_tfFirstName resignFirstResponder];
    [_tfLastName resignFirstResponder];
    [_tfCity resignFirstResponder];
    [_tfArea resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if([textField isEqual:_tfCity])
    {
        CitiesTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CitiesTableViewController"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        [self dismissKeyboard];
        return NO;
    }
    else if([textField isEqual:_tfArea])
    {
        if(!_selectedCity.cityID)
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a city first" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        else
        {
            AreasTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AreasTableViewController"];
            vc.delegate = self;
            vc.city = _selectedCity;
            [self.navigationController pushViewController:vc animated:YES];
            [self dismissKeyboard];
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:_tfFirstName])
    {
        [_tfLastName becomeFirstResponder];
    }
    else if([textField isEqual:_tfLastName])
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

- (void)citySlected:(City*)city
{
    _selectedArea = nil;
    _tfArea.text = nil;
    _tfCity.text = city.cityName;
    _selectedCity = city;
}

-(void) areaSlected:(Area *)area forCity:(City *)city
{
    _tfArea.text = area.areaName;
    _selectedArea = area;
}

@end
