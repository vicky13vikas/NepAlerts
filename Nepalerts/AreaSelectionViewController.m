//
//  AreaSelectionViewController.m
//  Nepalerts
//
//  Created by Vikas Kumar on 01/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "AreaSelectionViewController.h"
#import "AreasTableViewController.h"
#import "AFAppClient.h"
#import "SVProgressHUD.h"

@interface AreaSelectionViewController ()<AreaDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfArea;

@end

@implementation AreaSelectionViewController

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
    
    _tfArea.text = _areasList[0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    AreasTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AreasTableViewController"];
    vc.delegate = self;
    vc.areaList = _areasList;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}


-(void)areaSlected:(NSString*)area
{
    _tfArea.text = area;
}


-(NSDictionary *)getParameters
{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:DEVICE_TOKEN];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                _selectedState, @"State",
                                _selectedCity, @"City",
                                _tfArea.text, @"Area",
                                deviceToken, @"RegId",
                                deviceToken, @"OS",
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


@end
