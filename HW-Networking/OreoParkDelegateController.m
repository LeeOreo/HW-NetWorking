//
//  OreoParkDelegateController.m
//  HW-Networking
//
//  Created by 李育豪 on 2015/4/14.
//  Copyright (c) 2015年 ALPHACamp. All rights reserved.
//

#import "OreoParkDelegateController.h"
#import "OreoParkInfoCell.h"
#import "OreoMapViewController.h"
#import "OreoCoordinateFinder.h"
#import <MapKit/MapKit.h>

@interface OreoParkDelegateController () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableArray *parkInfoArray;
@property (nonatomic, strong) UIRefreshControl *refreshLoadingControl;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) OreoCoordinateFinder *coordinateFinder;
@property (weak, nonatomic) IBOutlet UILabel *stitleLabel;

@end



@implementation OreoParkDelegateController

// http://data.taipei.gov.tw/opendata/apply/NewDataContent;jsessionid=3A72E7293456D38F190F78FD2EBDC802?oid=683965F5-7E23-4134-ADB1-99C4FB1EA517
#define kOpenDataParkAPI  @"http://data.taipei.gov.tw/opendata/apply/json/NjgzOTY1RjUtN0UyMy00MTM0LUFEQjEtOTlDNEZCMUVBNTE3"

- (void)awakeFromNib{
    //preare dtata & array
    
    _responseData = [[NSMutableData alloc] init];
    _parkInfoArray = [[NSMutableArray alloc] init];
}
- (void)viewDidLoad{
    //
    
    [super viewDidLoad];
    
    self.title = @"Park with Delegate";
    _refreshLoadingControl = [[UIRefreshControl alloc] init];
    [_refreshLoadingControl addTarget:self action:@selector(prepareAPICall) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshLoadingControl];
    
    [self prepareAPICall];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"moveToMap"]) {
        
        // Retreive object from tableview selected.
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        NSDictionary *currentData = [_parkInfoArray objectAtIndex:selectedIndexPath.row];
        
        // Pass object mapitem into destination view controller.
        
        

        if ([segue.destinationViewController isKindOfClass:[OreoMapViewController class]]) {
            OreoMapViewController *temp = (OreoMapViewController *) segue.destinationViewController;
            temp.locationInfo = currentData;
            NSLog(@"yoyo");
        }
    }
}


- (void)prepareAPICall{
    //step 0. prepare loading view
    [self.refreshLoadingControl beginRefreshing];
    //step 1. prepare API URL
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kOpenDataParkAPI]];
    //step 2. prepare URL Connection, with request from step 1. inside. Also setup delegate target.
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //step 3. Start connection call.
    [connection start];
    //step 4. Clear response data
    [self.responseData setLength:0];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //remove loading view
    [self.refreshLoadingControl endRefreshing];
    
    // Serialize from data to json object.
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:self.responseData options: NSJSONReadingMutableContainers error: nil];
    
    // Remove all previous data.
    [_parkInfoArray removeAllObjects];
    
    // Add all data into info array.
    [_parkInfoArray addObjectsFromArray:jsonArray];
    
    // Reload Table View.
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _parkInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OreoParkInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ParkInfoCell" forIndexPath:indexPath];
    
    // Get data from park info arry. From each row.
    NSDictionary *eachParkData = [_parkInfoArray objectAtIndex:indexPath.row];
    
    //覺得下面太長可以做Category
    
    if ([eachParkData objectForKey:@"stitle"] && [eachParkData objectForKey:@"stitle"] != [NSNull null]) {
        cell.stitleLabel.text = [eachParkData objectForKey:@"stitle"];
    }
    if ([eachParkData objectForKey:@"xbody"] && [eachParkData objectForKey:@"xbody"] != [NSNull null]) {
        cell.bodyLabel.text = [eachParkData objectForKey:@"xbody"];
    }
    if ([eachParkData objectForKey:@"xAddress"] && [eachParkData objectForKey:@"xAddress"] != [NSNull null]) {
        cell.addressLabel.text = [eachParkData objectForKey:@"xAddress"];
    }
    if ([eachParkData objectForKey:@"category"] && [eachParkData objectForKey:@"category"] != [NSNull null]) {
        cell.addressLabel.text = [eachParkData objectForKey:@"category"];
    }
    return cell;
}

@end
