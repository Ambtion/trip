//
//  UploadViewManager.m
//  AhaTrip
//
//  Created by sohu on 13-8-5.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "UploadViewControllerManager.h"

@interface UploadViewControllerManager ()
@property(nonatomic,strong)NSMutableArray * menuArr;
@end

@implementation UploadViewControllerManager

- (id)initWithCateroyId:(PicUploadCateroy)cateroyId
{
    SingleMenuViewController * sigle =  [[SingleMenuViewController alloc] initWithCateroyId:cateroyId];
    sigle.delegate = self;
    if (self = [super initWithRootViewController:sigle]) {
        _cateroyId = cateroyId;
        [self.navigationBar setHidden:YES];
    }
    return self;
}
#pragma mark -  SingeMenu
- (void)singleClickNavBarRightButton:(id)object
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)singleClickTabBarRightButton:(id)object
{
    
    AllMenuViewController * allMenu=[[AllMenuViewController alloc] init];
    allMenu.delegate = self;
    [self presentModalViewController:allMenu animated:YES];
}
- (void)singleSelectedSubCateroyWihtInfo:(NSDictionary *)info
{
    SeletedPhotoMethodController *photoCTL=[[SeletedPhotoMethodController alloc] init];
    photoCTL.delegate = self;
    [self pushViewController:photoCTL animated:YES];
    return;
    
    _subCateroyInfo = info;
    CountryListController * souSuoCTL = [[CountryListController alloc] init];
    souSuoCTL.delegate = self;
    [self pushViewController:souSuoCTL animated:YES];
}

#pragma mark - Cateroy
- (void)allMenuViewChangeCateroy:(PicUploadCateroy)cateroy
{
    SingleMenuViewController * root = [[self viewControllers] objectAtIndex:0];
    root.cateroyId = cateroy;
}

#pragma mark - Country
- (void)countryListControllerSeletedCountry:(NSDictionary *)countryInfo
{
    _countryInfo = countryInfo;
    CityListController * ctl = [[CityListController alloc] init];
    ctl.countryInfo = countryInfo;
    ctl.delegate = self;
    [self pushViewController:ctl animated:YES];
}
#pragma mark - City
- (void)cityListControllerDidSeletedCityInfo:(NSDictionary *)info
{
    _cityInfo = info;
    SeletedPhotoMethodController *photoCTL=[[SeletedPhotoMethodController alloc] init];
    photoCTL.delegate = self;
    [self pushViewController:photoCTL animated:YES];
}

#pragma mark - Seleted 
- (void)seletedPhotoMethodControllerDidClickOpneView:(UIButton *)button
{
    DLCImagePickerController * picker = [[DLCImagePickerController alloc] init];
    picker.delegate = self;
    if (button.tag == KbuttonTagOpenAssetsLib) {
        [self pushViewController:picker animated:NO];
        [picker switchToLibrary:nil];
    }else{
        [self pushViewController:picker animated:YES];
    }
}

- (void)DLImagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [self popViewControllerAnimated:YES];
//    if (info) {
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        ALAsset *asset;
//        
//        //        NSDictionary *metadata= [[[asset defaultRepresentation] metadata] objectForKey:@"data"];
//        [library writeImageDataToSavedPhotosAlbum:[info objectForKey:@"data"] metadata:info completionBlock:^(NSURL *assetURL, NSError *error)
//         {
//             if (error) {
//                 NSLog(@"ERROR: the image failed to be written");
//             }
//             else {
//                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
//                 //                 NSString * nsALAssetPropertyDate = [library valueForProperty:ALAssetPropertyDate] ;
//                 NSLog(@"%@",[[asset defaultRepresentation] metadata]);
//                 
//                 
//             }
//         }];
//    }
//    
//    
//    NSData*date= UIImageJPEGRepresentation(currentFilteredVideoFrame, 0.5);
//    UIImage*iii=[UIImage imageWithData:date];
    //    PersonalViewController*personCTL=[[PersonalViewController alloc] init];
    //
    //    [self presentModalViewController:personCTL animated:YES];
    //
    MapViewController*mapCTL=[[MapViewController alloc] init];
    mapCTL.delegate=self;
    [self pushViewController:mapCTL animated:YES];
}

#pragma mark - MapViewDelegate
- (void)mapViewControllerDidCancel:(MapViewController *)picker
{
    [self popViewControllerAnimated:YES];
}
- (void)mapViewControllerDidSearch:(MapViewController *)picker
{
    
}
- (void)mapViewControllerDidSkip:(MapViewController *)picker
{
    
}
@end
