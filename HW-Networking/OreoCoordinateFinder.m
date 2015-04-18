//
//  OreoCoordinateFinder.m
//  HW-Networking
//
//  Created by 李育豪 on 2015/4/14.
//  Copyright (c) 2015年 ALPHACamp. All rights reserved.
//

#import "OreoCoordinateFinder.h"

@implementation OreoCoordinateFinder

- (id)initWithAddressOrPOI:(NSString *)address region:(MKCoordinateRegion)inRegion {
    [self forwardGeocodeAddress:address inRegion:inRegion];
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)forwardGeocodeAddress:(NSString *)address inRegion:(MKCoordinateRegion)inRegion {
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    _mapItems = [[NSMutableArray alloc] init];
    
    searchRequest.naturalLanguageQuery = address;
    searchRequest.region = inRegion;
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        BOOL hasFound = NO;
        if (!error) {
            
            for (MKMapItem *mapItem in response.mapItems) {
                [self.mapItems addObject:mapItem];
                hasFound = YES;
            }
            
        }
        if (hasFound) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_ADDRESS_FOUND object:self];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_ADDRESS_NOT_FOUND object:self];
        }
    }];
}

@end
