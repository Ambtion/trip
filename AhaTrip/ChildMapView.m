//
//  ChildMapView.m
//  XQSearchPlaces
//
//  Created by iObitLXF on 5/20/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "ChildMapView.h"
#import "UIImageView+DispatchLoad.h"
#import "PlaceAnnotation.h"

@implementation ChildMapView

+(ChildMapView*)getInstanceWithNibWithPlaceDetailVO:(PlaceDetailVO *)aVO
{
    ChildMapView *aView = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"ChildMapView" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[ChildMapView class]]){
            
            aView = (ChildMapView *)obj;
            break;
        }
    }
    aView.placeDetailVO = aVO;
    return aView;

}

-(void)setUI
{
    [self setRegion];
    
    self.imageView.alpha = 0;
    [self.imageView setImageFromUrl:self.placeDetailVO.pIconURLStr completion:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.alpha = 1;
        }];
    }];
    
}

-(void)setRegion
{
    CLLocationCoordinate2D coor;
    coor.latitude = [self.placeDetailVO.pLatStr floatValue];
    coor.longitude = [self.placeDetailVO.pLngStr floatValue];
    //    以上代码创建一个以center为中心，上下各1000米，左右各1000米得区域，但其是一个矩形，不符合MapView的横纵比例
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coor,800, 800);
    
    //    以上代码创建出来一个符合MapView横纵比例的区域
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    NSString *titleStr = [NSString stringWithFormat:@"(%@,%@)",self.placeDetailVO.pLatStr,self.placeDetailVO.pLngStr];
    PlaceAnnotation *placeAnno = [[PlaceAnnotation alloc]initWithCoords:coor];
    placeAnno.title = self.placeDetailVO.pNameStr;
    placeAnno.subtitle = titleStr;
  
   [self.mapView addAnnotation:placeAnno];

  
}
@end
