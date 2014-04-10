//
//  AreasTableViewController.m
//  Nepalerts
//
//  Created by Vikas Kumar on 10/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "AreasTableViewController.h"
#import "AFAppClient.h"
#import "SVProgressHUD.h"

@interface AreasTableViewController ()<UIAlertViewDelegate>

@end

@implementation AreasTableViewController

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
    
//    [self requestAreasForCurrentCity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _areaList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AreaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
        cell.textLabel.text = @"Could not find your area...." ;
    }
    else
    {
        cell.textLabel.text = _areaList[indexPath.row - 1] ;
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Area" message:@"Please enter your area" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    }
    else
    {
        [_delegate areaSlected:_areaList[indexPath.row - 1] forCity:_city];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_delegate areaSlected:[[alertView textFieldAtIndex:0] text] forCity:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Server Request
/*
-(void)requestAreasForCurrentCity
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    
    [[AFAppClient sharedClient] GET:[NSString stringWithFormat:@"InfoSevice.svc/GetAreasOf/%lu",(unsigned long)_city.cityID]
                         parameters:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [SVProgressHUD dismiss];
                                
                                NSError *error = nil;
                                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                
                                for (NSDictionary *attributes in response) {
                                    Area *area = [[Area alloc] initWithAttributes:attributes];
                                    area.city = _city;
                                    [_areaList addObject:area];
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
