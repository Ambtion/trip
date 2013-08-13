//
//  NewPlaceViewController.m
//  AhaTrip
//
//  Created by xuwenjuan on 13-8-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "NewPlaceViewController.h"
#import "Constants.h"
@interface NewPlaceViewController ()

@end

@implementation NewPlaceViewController
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBar];
}
- (void)addNavBar
{
    //加载topBar
    self.view.backgroundColor=mRGBColor(236, 235, 235);
    UIImageView* topBarImag =[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 44)];
    topBarImag.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:topBarImag];
    [topBarImag setUserInteractionEnabled:YES];
    // 添加位置的label
    UILabel * addPlaceLable=[[UILabel alloc] initWithFrame:CGRectMake(15, 3, 100, 40)];
    addPlaceLable.text= @"添加新位置";
    addPlaceLable.font= [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    addPlaceLable.backgroundColor=[UIColor clearColor];
    addPlaceLable.textColor=[UIColor whiteColor];
    [self.view addSubview:addPlaceLable];
}
- (void)setMapViewsPerpoty
{
    self.mapView.showsUserLocation = YES;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //开启GPS
    if(CLLocationManager.locationServicesEnabled) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度
        locationManager.distanceFilter = 5.0f;//响应位置变化的最小距离(m)
        [locationManager startUpdatingLocation];
    }
}

#pragma mark LocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DLog();
	CGFloat lat = [newLocation coordinate].latitude;
	CGFloat lon	= [newLocation coordinate].longitude;
    
	CLLocationCoordinate2D theCenter;
	theCenter.latitude =lat;
	theCenter.longitude = lon;
    
	MKCoordinateRegion theRegin = self.mapView.region;
	theRegin.center = theCenter;
    
	MKCoordinateSpan theSpan;
	theSpan.latitudeDelta = 0.005;
	theSpan.longitudeDelta = 0.005;
	theRegin.span = theSpan;
    [self.mapView setRegion:theRegin];
    [self.mapView regionThatFits:theRegin];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
	[locationManager stopUpdatingLocation];
	[locationManager stopUpdatingHeading];
	[[self.mapView viewForAnnotation:[self.mapView userLocation]] setTransform:CGAffineTransformIdentity];
}

@end
