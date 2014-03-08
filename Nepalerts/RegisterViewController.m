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

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UITextField *tfArea;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDictionary *)getParameters
{
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"25", @"user_id",
                                nil];
    
    return parameters;
}

- (IBAction)submitTapped:(id)sender
{
    AFURLConnectionOperation *operation = [[AFAppClient sharedClient] POST:@"RegistrationService.svc/StartRegister"
                          parameters:[self getParameters]
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                                 NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];

                                 NSLog(@"%@", string);
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 NSLog(@"%@", error);
                             }];
    
//    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    [activityIndicator setAnimatingWithStateOfOperation:operation];
//    activityIndicator.frame = CGRectMake(100, 100, CGRectGetWidth(activityIndicator.frame), CGRectGetHeight(activityIndicator.frame));
//    [self.view addSubview:activityIndicator];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
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

@end
