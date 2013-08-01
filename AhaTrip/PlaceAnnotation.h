//
//  DefinedAnnotation.h
//  LXF_MapGuideDemo
//
//  Created by developer on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PlaceAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D      coordinate;
	NSString                    *subtitle;
	NSString                    *title;	
	NSString                    *annoType;
    CGFloat                     aAngle;
    
}
@property (nonatomic, readonly)      CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)          NSString *annoType;
@property (nonatomic, copy)          NSString *subtitle;
@property (nonatomic, copy)          NSString *title;
@property (nonatomic, assign)        CGFloat  aAngle;

-(id)initWithCoords:(CLLocationCoordinate2D)coords;
@end
