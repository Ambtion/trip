//
//  LocationManager.h
//  Line0New
//
//  Created by line0 on 13-4-23.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

/*－－－－－－－－－位置管理器管理地图，位置解析等，以单例模式运行－－－－－－－－－－*/

#import <Foundation/Foundation.h>
#import "MapView.h"

@interface LocationManager : NSObject
@property (strong, nonatomic) MapView           *mapView;

//检查位置服务是否开启
+ (void)checkLocationServices;

+ (LocationManager *)sharedInstance;

- (void)showMapView;
- (void)hideMapView;
- (void)startUpdateLocation:(BOOL)autoUpdate;
- (void)stopUpdateLocation;

@end
