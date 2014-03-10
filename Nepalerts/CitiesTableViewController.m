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
{
    NSMutableArray *   _citiesList;
}

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
    _citiesList = [[NSMutableArray alloc] init];
    [self requsetListOfCities];
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

    return _citiesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [((City*)_citiesList[indexPath.row]) cityName];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate citySlected:_citiesList[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Sever Request -

-(void)requsetListOfCities
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    
    [[AFAppClient sharedClient] GET:@"InfoSevice.svc/GetAllCities"
                          parameters:nil
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [SVProgressHUD dismiss];
                                 
                                 NSError *error = nil;
                                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                 
                                 for (NSDictionary *attributes in response) {
                                     NSLog(@"ID : %@, Name :  %@", [attributes valueForKeyPath:@"id"], [attributes valueForKeyPath:@"name"]);
                                     City *city = [[City alloc] initWithAttributes:attributes];
                                     [_citiesList addObject:city];
                                 }
                                 
                                 [self.tableView reloadData];
                                 
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [SVProgressHUD dismiss];
                                 NSLog(@"%@", error);
                             }];

}

@end
