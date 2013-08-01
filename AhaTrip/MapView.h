//
//  MapVC.h
//  Line0New
//
//  Created by line0 on 13-4-22.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import "CoreLocation/CoreLocation.h"
#import "Constants.h"
//位置更新通知
#define kUpdateLocationFinished      @"updateLocationFinished"

@interface MapView : UIView<CLLocationManagerDelegate>;
@property (strong, nonatomic) MKMapView   *mapView;

//参数autoUpdate用于判断是否自动更新位置，若为YES，则默认自动修改购物地址，并清空本地购物车
- (void)startUpdateLocation:(BOOL)autoUpdate;
- (void)stopUpdateLocation;

@end
