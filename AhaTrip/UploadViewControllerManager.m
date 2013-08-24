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
    
//    tempInfoController = [[UploadInfoViewController alloc] initWithImageUrls:[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"test_portrait"],[UIImage imageNamed:@"test_portrait"],[UIImage imageNamed:@"test_portrait"],[UIImage imageNamed:@"test_portrait"],nil]];
//    tempInfoController.delegate = self;
//    [self pushViewController:tempInfoController animated:YES];
//    return;
//    MapViewController * mv = [[MapViewController alloc] init];
//    [self pushViewController:mv animated:YES];
//    return;
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

#pragma mark - Seleted PicMethod
- (void)seletedPhotoMethodControllerDidClickOpneView:(UIButton *)button
{
    DLCImagePickerController * picker = [[DLCImagePickerController alloc] init];
    picker.delegate = self;
    if (button.tag == KbuttonTagOpenAssetsLib) {
        [self pushViewController:picker animated:NO];
        [picker switchToLibraryWithAnimaion:NO];
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
                DLog(@"%@",error);
            }else {
                if (![self array:_imageUrlArray containURL:assetURL]){
                    DLog(@"%d %@",[self array:_imageUrlArray containURL:assetURL],assetURL);
                    [[self defaultLib] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSMutableDictionary *  dic = [NSMutableDictionary dictionaryWithDictionary:info];
                            [dic setValue:[UIImage imageWithCGImage:[asset thumbnail]] forKey:@"Thumbnail"];
                            [dic setValue:assetURL forKey:@"URL"];
                            [_imageUrlArray addObject:dic];
                            if (!tempInfoController) {
                                tempInfoController =[[UploadInfoViewController alloc] initWithImageUrls:_imageUrlArray];
                                tempInfoController.delegate = self;
                            }
                            if (![self.childViewControllers containsObject:tempInfoController]) {
                                [self pushViewController:tempInfoController animated:YES];
                            }else{
                                [self popToViewController:tempInfoController animated:YES];
                            }
                        });
                        
                    } failureBlock:^(NSError *error) {
                        
                    }];
                }else{
                    //相同的图片
                }
            }
        }];
    }
}

- (BOOL)array:(NSArray*)array containURL:(NSURL *)url
{
    for (NSDictionary * info in array) {
        NSURL * tempUrl = [info objectForKey:@"URL"];
        if ([url isEqual:tempUrl]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - MapViewDelegate
- (void)mapViewControllerDidCancel:(MapViewController *)picker
{
    [self popViewControllerAnimated:YES];
}
- (void)mapViewControllerDidSeletedLocation:(NSString *)locationName
{
    _locationName = locationName;
    [tempInfoController setLocationText:_locationName];
    [self popViewControllerAnimated:YES];
}

#pragma mark UploadInfo
- (void)uploadInfoViewControllerDidClickAddPic:(UIButton *)button
{
    if (_imageUrlArray.count >= 6) {
        [self showPopAlerViewWithMes:@"上传图片数量已尽最大"];
        return;
    }
    SeletedPhotoMethodController * photoCTL=[[SeletedPhotoMethodController alloc] init];
    photoCTL.delegate = self;
    [self pushViewController:photoCTL animated:YES];
}
- (void)uploadInfoViewControllerDidClickSender:(NSDictionary *)info
{
    [RequestManager uploadPics:_imageUrlArray withCountryId:[[_countryInfo objectForKey:@"id"] integerValue] city_id:[[_cityInfo objectForKey:@"id"] integerValue] category_id:_cateroyId sub_category_id:[[_subCateroyInfo objectForKey:@"id"] integerValue] position:_locationName description:[info objectForKey:@"Des"] business_hours_start:[info objectForKey:@"StartTime"] business_hours_end:[info objectForKey:@"EndTime"] price:[[info objectForKey:@"Price"] intValue] price_unit_id:[[info objectForKey:@"PriceUnit"] intValue] hasWifi:[[info objectForKey:@"WiFi"] boolValue] success:^(NSString *response) {
        [self showTotasViewWithMes:@"上传成功"];
        DLog(@"%@",self.presentingViewController);
        [self.presentingViewController changeToHome];
        [self dismissModalViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [self showTotasViewWithMes:@"上传失败,稍后重试"];
    }];
}
- (void)uploadInfoViewControllerDidClickAddLocation:(UIButton *)button
{
    MapViewController * map = [[MapViewController alloc] init];
    map.delegate = self;
    [self pushViewController:map animated:YES];
}
@end
