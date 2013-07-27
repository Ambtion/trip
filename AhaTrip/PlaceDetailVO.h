//
//  PlaceDetail.h
//  LXF_MapGuideDemo
//
//  Created by developer on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
@interface PlaceDetailVO : NSObject{
    NSString                    *pLatStr;
    NSString                    *pLngStr;
    NSString                    *pIconURLStr;
    NSString                    *pIDStr;
    NSString                    *pNameStr;
    NSString                    *pReferenceStr;
    NSString                    *pVicinityStr;
    NSString                    *pPhotoReferenceStr;
    NSString                    *pHtmlAttributionStr;
    
    
}

@property(nonatomic, copy)    NSString                     *pLatStr;
@property(nonatomic, copy)    NSString                     *pLngStr;
@property(nonatomic, copy)    NSString                     *pIconURLStr;
@property(nonatomic, copy)    NSString                     *pIDStr;
@property(nonatomic, copy)    NSString                     *pNameStr;
@property(nonatomic, copy)    NSString                     *pReferenceStr;
@property(nonatomic, copy)    NSString                     *pVicinityStr;
@property(nonatomic, copy)    NSString                     *pPhotoReferenceStr;
@property(nonatomic, copy)    NSString                     *pHtmlAttributionStr;
@end
