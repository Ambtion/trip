//
//  SearchPlazaViewController.h
//  AhaTrip
//
//  Created by Qu on 13-7-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlazeViewController.h"

@interface SearchPlazaViewController : PlazeViewController
{
    PicUploadCateroy _cateroy;
    UIView *  _segControllView;
    int _countryId;
    NSString * _countryName;
    int _cityId;
    NSString * _cityName;
}

@property(nonatomic,assign)BOOL isOthersSource;
- (id)initWithCountryId:(int)AcountyId cityId:(int)AcityId  country:(NSString *)country city:(NSString *)city;

@end
