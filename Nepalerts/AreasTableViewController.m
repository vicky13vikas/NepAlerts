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

@interface AreasTableViewController ()

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
    return _areaList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AreaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _areaList[indexPath.row] ;
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate areaSlected:_areaList[indexPath.row] forCity:_city];
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
