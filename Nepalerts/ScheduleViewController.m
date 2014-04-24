//
//  ScheduleViewController.m
//  Nepalerts
//
//  Created by Vikas Kumar on 24/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "ScheduleViewController.h"
#import "AFAppClient.h"
#import "SVProgressHUD.h"

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self loadMessagesFromServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

-(void)loadMessagesFromServer
{
    SVProgressHUD *progressHud = [SVProgressHUD appearance];
    progressHud.hudBackgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeClear];
    
    NSString *state = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastRegisterdState"];
    NSString *city = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastRegisterdCity"];
    NSString *area = [[NSUserDefaults standardUserDefaults] valueForKey:@"LastRegisterdArea"];
    
    NSString *url = [[NSString stringWithFormat:@"RegistrationService.svc/GetPushContent/%@/%@/%@",state,city,area] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppClient sharedClient] GET: url
                          parameters:nil
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
                                 [[[UIAlertView alloc] initWithTitle:@"Nep Alerts" message:@"Request Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                 NSLog(@"%@", error);
                             }];

}

@end
