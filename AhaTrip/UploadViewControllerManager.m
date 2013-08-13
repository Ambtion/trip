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
//    UploadInfoViewController * uc = [[UploadInfoViewController alloc] initWithImageUrls:[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"test_portrait"],[UIImage imageNamed:@"test_portrait"],[UIImage imageNamed:@"test_portrait"],[UIImage imageNamed:@"test_portrait"],nil]];
//    [self pushViewController:uc animated:YES];
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
                 DLog(@"%d %@",[self array:_imageUrlArray containURL:assetURL],assetURL);
                 if (![self array:_imageUrlArray containURL:assetURL]){
                    [[self defaultLib] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSMutableDictionary *  dic = [NSMutableDictionary dictionaryWithDictionary:info];
                            [dic setValue:[UIImage imageWithCGImage:[asset thumbnail]] forKey:@"Thumbnail"];
                            [dic setValue:assetURL forKey:@"URL"];
                            [_imageUrlArray addObject:dic];
                            [self popViewControllerAnimated:NO];
                            if (!tempInfoController) {
                                tempInfoController =[[UploadInfoViewController alloc] initWithImageUrls:_imageUrlArray];
                                tempInfoController.delegate = self;
                            }
                            [self pushViewController:tempInfoController animated:YES];
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
   [self popViewControllerAnimated:NO];
}
- (void)mapViewControllerDidSeletedLocation:(NSString *)locationName
{
    _locationName = locationName;
    [tempInfoController setLocationText:_locationName];
    [self popViewControllerAnimated:NO];
}

#pragma mark UploadInfo
- (void)uploadInfoViewControllerDidClickAddPic:(UIButton *)button
{
    [self popViewControllerAnimated:NO];
    SeletedPhotoMethodController *photoCTL=[[SeletedPhotoMethodController alloc] init];
    photoCTL.delegate = self;
    [self pushViewController:photoCTL animated:YES];
}
- (void)uploadInfoViewControllerDidClickSender:(NSDictionary *)info
{
    
}
- (void)uploadInfoViewControllerDidClickAddLocation:(UIButton *)button
{
    [self popViewControllerAnimated:NO];
    MapViewController * map = [[MapViewController alloc] init];
    map.delegate = self;
    [self pushViewController:map animated:YES];
}
@end
