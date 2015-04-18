//
//  OreoParkCompletionController.m
//  HW-Networking
//
//  Created by 李育豪 on 2015/4/18.
//  Copyright (c) 2015年 ALPHACamp. All rights reserved.
//

#import "OreoParkCompletionController.h"
#import "OreoParkInfoCell.h"

@interface OreoParkCompletionController ()

@property (nonatomic, strong) NSMutableArray *parkInfoArray;
@property (nonatomic, strong) UIRefreshControl *refreshLoadingControl;

@end

@implementation OreoParkCompletionController
// http://data.taipei.gov.tw/opendata/apply/NewDataContent;jsessionid=3A72E7293456D38F190F78FD2EBDC802?oid=683965F5-7E23-4134-ADB1-99C4FB1EA517
#define kOpenDataParkAPI  @"http://data.taipei.gov.tw/opendata/apply/json/NjgzOTY1RjUtN0UyMy00MTM0LUFEQjEtOTlDNEZCMUVBNTE3"
- (void)awakeFromNib{
    _parkInfoArray = [[NSMutableArray alloc] init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Park with Completion";
    
    _refreshLoadingControl = [[UIRefreshControl alloc] init];
    [_refreshLoadingControl addTarget:self action:@selector(prepareAPICall) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:_refreshLoadingControl];
    
    [self prepareAPICall];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)prepareAPICall {
    
    // Step 0. Prepare loading view.
    [self.refreshLoadingControl beginRefreshing];
    
    // Step 1. Prepare API URL.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kOpenDataParkAPI] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    
    // Step 2. Use URL Connection so send async request call.
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // Step 3. Handle call back
        
        // End of loading view
        [self.refreshLoadingControl endRefreshing];
        
        // Check if have error.
        if (!connectionError) {
            NSError *jsonSerializationError;
            
            // Serialize data into JSONObject.
            id unknowObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonSerializationError];
            
            if ([unknowObject isKindOfClass:[NSArray class]]) {
                NSArray *jsonArray = unknowObject;
                
                // Remove all previous data.
                [_parkInfoArray removeAllObjects];
                
                // Add all data into info array.
                [_parkInfoArray addObjectsFromArray:jsonArray];
                
                // Reload Table View.
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            
        } else {
            NSLog(@"Connection with: %@", connectionError);
        }
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
