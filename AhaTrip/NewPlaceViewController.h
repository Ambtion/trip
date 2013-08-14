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

@class NewPlaceViewController;

@interface NewPlaceAnnotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * address;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
@end


@protocol NewPlaceViewControllerDelegate <NSObject>
- (void)newPlaceViewControllerButtonClick:(NSString *)name address:(NSString *)address Location:(CLLocationCoordinate2D )coordinate;
@end
@interface NewPlaceViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
    CLLocationManager * locationManager;
    CLLocationCoordinate2D touchCoordinate;
}

@property (nonatomic,strong)id<NewPlaceViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *LocationNameFiled;
@property (weak, nonatomic) IBOutlet UITextField *LocationAddressFiled;
@property (weak, nonatomic) IBOutlet  MKMapView *mapView;
@end
