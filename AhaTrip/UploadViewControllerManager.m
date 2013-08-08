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
    MapViewController*mapCTL=[[MapViewController alloc] init];
    mapCTL.delegate=self;
    [self pushViewController:mapCTL animated:YES];
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
    if (!_imageUrlArray)
        _imageUrlArray = [NSMutableArray arrayWithCapacity:0];
    if (info) {
        UIImage * image = [info objectForKey:@"Image"];
        [[self defaultLib] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error){
            
             if (error) {
                 NSLog(@"ERROR: the image failed to be written");
                 MapViewController * mapCTL=[[MapViewController alloc] init];
                 mapCTL.delegate=self;
                 [self pushViewController:mapCTL animated:YES];
             }
             else {
                 if (![_imageUrlArray containsObject:assetURL])
                     [_imageUrlArray addObject:assetURL];
                 [self popViewControllerAnimated:YES];
                 MapViewController * mapCTL=[[MapViewController alloc] init];
                 mapCTL.delegate=self;
                 [self pushViewController:mapCTL animated:YES];
             }
         }];
    }
}

#pragma mark - MapViewDelegate
- (void)mapViewControllerDidCancel:(MapViewController *)picker
{
    [self popViewControllerAnimated:YES];
}
- (void)mapViewControllerDidSkip:(MapViewController *)picker
{
    _locationName = nil;
    PersonalViewController*personal=[[PersonalViewController alloc] initWithLatitude:@"" longitude:@"" placeName:@"" image:[UIImage imageNamed:@"testImage.png"] singleCityId:@"" singleCityName:@"" cateryStr:@""];
    [self pushViewController:personal animated:YES];
}
- (void)mapViewControllerDidSeletedLocation:(NSString *)locationName
{
    _locationName = locationName;
    PersonalViewController*personal=[[PersonalViewController alloc] init];
    [self pushViewController:personal animated:YES];
}
@end
