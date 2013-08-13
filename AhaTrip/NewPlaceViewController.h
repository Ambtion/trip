//
//  NewPlaceViewController.h
//  AhaTrip
//
//  Created by xuwenjuan on 13-8-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NewPlaceViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
}
@property (weak, nonatomic) IBOutlet  MKMapView *mapView;
@end
