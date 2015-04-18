//
//  OreoMapViewController.h
//  HW-Networking
//
//  Created by 李育豪 on 2015/4/14.
//  Copyright (c) 2015年 ALPHACamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface OreoMapViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSDictionary *locationInfo;

@end
