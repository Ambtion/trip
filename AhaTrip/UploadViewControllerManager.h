//
//  UploadViewManager.h
//  AhaTrip
//
//  Created by sohu on 13-8-5.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleMenuViewController.h"
#import "AllMenuViewController.h"
#import "CountryListController.h"
#import "CityListController.h"
#import "SeletedPhotoMethodController.h"
#import "DLCImagePickerController.h"
#import "MapViewController.h"
#import "UploadInfoViewController.h"

#import "BusinessTimeController.h" //Fortest

@interface UploadViewControllerManager : UINavigationController<SingleMenuViewDelegate,AllMenuViewDeletage,CountryListViewDelegate,CityListControllerDelegate,SeletedPhotoMethodDelegate,DLCImagePickerDelegate,MapViewDelegate,UploadInfoViewControllerDelegate>
{
    PicUploadCateroy _cateroyId;
    NSDictionary * _subCateroyInfo;
    NSDictionary * _countryInfo;
    NSDictionary * _cityInfo;
    NSMutableArray * _imageUrlArray;
    NSString * _locationName;
    
    UploadInfoViewController * tempInfoController;
}

- (id)initWithCateroyId:(PicUploadCateroy)cateroyId;
@end
