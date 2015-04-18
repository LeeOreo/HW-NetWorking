//
//  OreoParkNetworkingController.m
//  HW-Networking
//
//  Created by 李育豪 on 2015/4/18.
//  Copyright (c) 2015年 ALPHACamp. All rights reserved.
//

#import "OreoParkNetworkingController.h"
#import "OreoParkInfoCell.h"
#import <AFNetworking/AFNetworking.h>

@interface OreoParkNetworkingController ()

@property (nonatomic, strong) NSMutableArray *parkInfoArray;
@property (nonatomic, strong) UIRefreshControl *refreshLoadingControl;

@end

@implementation OreoParkNetworkingController

// http://data.taipei.gov.tw/opendata/apply/NewDataContent;jsessionid=3A72E7293456D38F190F78FD2EBDC802?oid=683965F5-7E23-4134-ADB1-99C4FB1EA517
#define kOpenDataParkAPI  @"http://data.taipei.gov.tw/opendata/apply/json/NjgzOTY1RjUtN0UyMy00MTM0LUFEQjEtOTlDNEZCMUVBNTE3"

- (void)awakeFromNib {
    _parkInfoArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Park with AFNetworking";
    
    _refreshLoadingControl = [[UIRefreshControl alloc] init];
    [_refreshLoadingControl addTarget:self action:@selector(prepareAPICall) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshLoadingControl];
    
    [self prepareAPICall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private

- (void)prepareAPICall{
    //step 0. prepare loading view
    [self.refreshLoadingControl beginRefreshing];
    // step 1. prepare API call
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // i do not know text/plain ,plz tell me
    
    [manager GET:kOpenDataParkAPI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // step 2. Get response
        NSArray *jsonArray = responseObject;
        
        // remove all previous data
        [_parkInfoArray removeAllObjects];
        
        // step 3. Put data into park info array
        // add all data into park info array
        [_parkInfoArray addObjectsFromArray:jsonArray];
        
        // step 4. stop loading view
        // end of loading view
        [self.refreshLoadingControl endRefreshing];
        
        // step 5. table view reload
        // reload table view
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
