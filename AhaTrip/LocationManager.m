//
//  LocationManager.m
//  Line0New
//
//  Created by line0 on 13-4-23.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import "LocationManager.h"
#import "CoreLocation/CoreLocation.h"
#import "AppDelegate.h"

@implementation LocationManager

+ (void)checkLocationServices
{
    if (![CLLocationManager locationServicesEnabled])
    {
//        mAlertView(@"定位服务", @"您的定位服务未开启，请在设置里启用定位服务");
    }
    else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized)
    {
//        mAlertView(@"定位服务", @"您的定位服务未对零号线开启，请在设置里启用零号线的定位服务");
    }
}

+ (LocationManager *)sharedInstance
{
    static LocationManager *locationManager = nil;
    if (!locationManager)
    {
        locationManager = [[LocationManager alloc] init];
    }
    return locationManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        UIWindow *window = mWindow;
        self.mapView = [[MapView alloc] initWithFrame:window.bounds];
        [self.mapView setHidden:YES];
        [window performSelector:@selector(addSubview:) withObject:self.mapView afterDelay:1];
    }
    return self;
}

- (void)showMapView
{
    [self.mapView startUpdateLocation:NO];
    [self.mapView setHidden:NO];
    [self.mapView setAlpha:0.0];
    [UIView animateWithDuration:1.0 animations:^
     {
         [self.mapView setAlpha:1.0];
     }];
}

- (void)hideMapView
{
    [self.mapView stopUpdateLocation];
    [self.mapView setAlpha:1.0];
    [UIView animateWithDuration:1.0
                     animations:^
     {
         [self.mapView setAlpha:0.0];
     }
                     completion:^(BOOL finished)
     {
         [self.mapView setHidden:YES];
     }];
}

- (void)startUpdateLocation:(BOOL)autoUpdate
{
    [self.mapView startUpdateLocation:autoUpdate];
}

- (void)stopUpdateLocation
{
    [self.mapView stopUpdateLocation];
}

@end
