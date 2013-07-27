//
//  DefinedAnnotation.m
//  LXF_MapGuideDemo
//
//  Created by developer on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlaceAnnotation.h"

@implementation PlaceAnnotation
@synthesize coordinate,subtitle,title,annoType;
@synthesize aAngle;
-(id)initWithCoords:(CLLocationCoordinate2D)coords{
	self = [super init];
    
	coordinate = coords;
    
	return self;
}
- (void)dealloc {
   
//    [subtitle release];
//    [title release];
//    [annoType release];
//    [super dealloc];
}
@end
