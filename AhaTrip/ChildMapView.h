//
//  ChildMapView.h
//  XQSearchPlaces
//
//  Created by iObitLXF on 5/20/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceDetailVO.h"

@interface ChildMapView : UIView
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) PlaceDetailVO        *placeDetailVO;
+(ChildMapView*)getInstanceWithNibWithPlaceDetailVO:(PlaceDetailVO *)aVO;
-(void)setUI;
@end
