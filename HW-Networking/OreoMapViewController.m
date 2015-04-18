//
//  OreoMapViewController.m
//  HW-Networking
//
//  Created by 李育豪 on 2015/4/14.
//  Copyright (c) 2015年 ALPHACamp. All rights reserved.
//

#import "OreoMapViewController.h"
#import "OreoCoordinateFinder.h"

@interface OreoMapViewController ()

@property (nonatomic, strong) OreoCoordinateFinder *coordinateFinder;


@end

@implementation OreoMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self addAnnotations];
    
    // Prepare location
    
    // Add to mapview
    
    double longtitude;
    double latitude;

    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(longtitude, latitude);
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = coor;
    
    //將經緯度轉為double
    NSNumber *myLatitude = [NSNumber numberWithDouble:latitude];
    NSNumber *myLongtitude = [NSNumber numberWithDouble:longtitude];
    //將dictionary的值拉出來
    myLatitude = [self.locationInfo objectForKey:@"GTag_latitude"];
    myLongtitude = [self.locationInfo objectForKey:@"GTag_longitude"];
    //將取出的經緯度放到coor中
    coor.latitude = [myLatitude doubleValue];
    coor.longitude = [myLongtitude doubleValue];
    
    NSLog(@"%f",coor.latitude);
    NSLog(@"%f",coor.longitude);
    
    myAnnotation.title = [self.locationInfo objectForKey:@"stitle"];
    
    [self.mapView addAnnotation:myAnnotation];
    
    if (self.mapView.annotations.count > 1) {
        [self zoomToVisibleUnion];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

//- (void)addAnnotations{
//    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
//    myAnnotation.coordinate = _locationInfo.mapItems.placemark.coordinate;
//}

//- (void)addAnnotations {
//    NSLog(@"Location Counts in addAnnotations: %lu", (unsigned long)self.targetLocations.count);
//    
//    for ( MKMapItem *mapItem in self.targetLocations ) {
//        
//        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
//        myAnnotation.coordinate = mapItem.placemark.coordinate;
//        myAnnotation.title = mapItem.name;
//        myAnnotation.subtitle = mapItem.placemark.title;
//        
//        NSLog(@"%.3f, %.3f", mapItem.placemark.coordinate.latitude, mapItem.placemark.coordinate.longitude);
//        
//        [self.mapView addAnnotation:myAnnotation];
//        
//    }
//    if (self.mapView.annotations.count > 1) {
//        [self zoomToVisibleUnion];
//    }
//}

- (void)zoomToVisibleUnion {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}



@end
