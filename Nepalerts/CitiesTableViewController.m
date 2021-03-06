//
//  CitiesTableViewController.m
//  Nepalerts
//
//  Created by Vikas Kumar on 10/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "CitiesTableViewController.h"
#import "AFAppClient.h"
#import "SVProgressHUD.h"
#import "City.h"

@interface CitiesTableViewController ()

@end

@implementation CitiesTableViewController

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
//    [self requsetListOfCities];
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

    return _citiesList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
        cell.textLabel.text = @"Could not find your city below...." ;
    }
    else
    {
        cell.textLabel.text = _citiesList[indexPath.row - 1] ;
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Area" message:@"Please enter your city" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
    else
    {
        [_delegate citySlected:_citiesList[indexPath.row - 1]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_delegate citySlected:[[alertView textFieldAtIndex:0] text]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Sever Request -
/*
-(void)requsetListOfCities
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    
    [[AFAppClient sharedClient] GET:[NSString stringWithFormat:@"InfoSevice.svc/GetCitiesOf/%lu",(unsigned long)_state.stateID]
                          parameters:nil
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [SVProgressHUD dismiss];
                                 
                                 NSError *error = nil;
                                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                 
                                 for (NSDictionary *attributes in response) {
                                     City *city = [[City alloc] initWithAttributes:attributes];
                                     city.state = _state;
                                     [_citiesList addObject:city];
                                 }
                                 [self.tableView reloadData];
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [SVProgressHUD dismiss];
                                 NSLog(@"%@", error);
                             }];

}
*/
@end
