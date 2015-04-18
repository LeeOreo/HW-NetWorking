//
//  OreoCoordinateFinder.h
//  HW-Networking
//
//  Created by 李育豪 on 2015/4/14.
//  Copyright (c) 2015年 ALPHACamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface OreoCoordinateFinder : NSObject

@property (nonatomic, readonly) NSMutableArray *mapItems;

- (id)initWithAddressOrPOI:(NSString *)address region:(MKCoordinateRegion)inRegion;

@end
#define kNOTIFICATION_ADDRESS_FOUND @"Address Found"
#define kNOTIFICATION_ADDRESS_NOT_FOUND @"Address Not Found"

