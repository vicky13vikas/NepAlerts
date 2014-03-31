//
//  StateTableViewController.m
//  Nepalerts
//
//  Created by Vikas kumar on 18/03/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "StateTableViewController.h"
#import "AFAppClient.h"
#import "SVProgressHUD.h"
#import "State.h"

@interface StateTableViewController ()

@end

@implementation StateTableViewController

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
//    [self requsetListOfStates];
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

    return _statesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _statesList[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_delegate stateSlected:_statesList[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Sever Request -
/*
-(void)requsetListOfStates
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    
    [[AFAppClient sharedClient] GET:@"InfoSevice.svc/GetAllStates"
                         parameters:nil
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                [SVProgressHUD dismiss];
                                
                                NSError *error = nil;
                                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
                                
                                for (NSDictionary *attributes in response) {
                                    State *state = [[State alloc] initWithAttributes:attributes];
                                    [_statesList addObject:state];
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
