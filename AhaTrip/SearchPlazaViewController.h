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
    NSString * _Atitle;
    int _countryId;
    int _cityId;
}

- (id)initWithCountryId:(int)AcountyId cityId:(int)AcityId title:(NSString *)Atitle;
@end
