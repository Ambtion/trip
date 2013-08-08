//
//  PhotoViewController.m
//  DLCImagePickerController
//
//  Created by Dmitri Cherniak on 8/18/12.
//  Copyright (c) 2012 Backspaces Inc. All rights reserved.
//

#import "SeletedPhotoMethodController.h"
#import "Constants.h"
#import "MapViewController.h"

@implementation SeletedPhotoMethodController
@synthesize delegate;

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor=mRGBColor(236, 235, 235);
    //    topbar
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];
    CGFloat offsety = 10.f;
    UIButton * cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cameraButton.frame = CGRectMake(round(self.view.frame.size.width / 2.0-75), 105 - offsety,150, 111);
    [cameraButton setImage:[UIImage imageNamed:@"FromCamera.png"] forState:UIControlStateHighlighted];
    [cameraButton setImage:[UIImage imageNamed:@"FromCamera_0.png"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    cameraButton.tag = KbuttonTagOpenCamera;
    [self.view addSubview:cameraButton];
    
    UIButton * assetsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    assetsButton.frame = CGRectMake(round(self.view.frame.size.width / 2.0-75), 250 - offsety,150, 111);
    [assetsButton setImage:[UIImage imageNamed:@"FromPic_0.png"] forState:UIControlStateNormal];
    [assetsButton setImage:[UIImage imageNamed:@"FromPic.png"] forState:UIControlStateHighlighted];

    assetsButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [assetsButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [assetsButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    assetsButton.tag = KbuttonTagOpenAssetsLib;
    [self.view addSubview:assetsButton];
	
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(15,7, 150, 30)];
    Accombodation.text=@"添加图片";
    Accombodation.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    Accombodation.textColor=[UIColor whiteColor];
    Accombodation.backgroundColor=[UIColor clearColor];
    [navView addSubview:Accombodation];
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 20;
    //    底部导航
    UIImageView * bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, height -55 ,320, 55)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10,height-40, 33, 33)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
}

-(void)closeBtnBackMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) takePhoto:(UIButton *)button
{
    if ([delegate respondsToSelector:@selector(seletedPhotoMethodControllerDidClickOpneView:)])
        [delegate seletedPhotoMethodControllerDidClickOpneView:button];
}

-(void) imagePickerControllerDidCancel:(DLCImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

//-(void) imagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
//    [self dismissModalViewControllerAnimated:YES];
//
////    if (info) {
////        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
////        [library writeImageDataToSavedPhotosAlbum:[info objectForKey:@"data"] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
////         {
////             if (error) {
////                 NSLog(@"ERROR: the image failed to be written");
////             }
////             else {
////                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
////             }
////         }];
////    }
////    UIImage *currentFilteredVideoFrame = [processUpTo imageFromCurrentlyProcessedOutputWithOrientation:staticPictureOriginalOrientation];
////
////    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:
////                          UIImageJPEGRepresentation(currentFilteredVideoFrame, self.outputJPEGQuality), @"data", nil];
////    if (info) {
////        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
////        ALAsset *asset;
////
////        //        NSDictionary *metadata= [[[asset defaultRepresentation] metadata] objectForKey:@"data"];
////        [library writeImageDataToSavedPhotosAlbum:[info objectForKey:@"data"] metadata:info completionBlock:^(NSURL *assetURL, NSError *error)
////         {
////             if (error) {
////                 NSLog(@"ERROR: the image failed to be written");
////             }
////             else {
////                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
////                 //                 NSString * nsALAssetPropertyDate = [library valueForProperty:ALAssetPropertyDate] ;
////                 NSLog(@"%@",[[asset defaultRepresentation] metadata]);
////
////
////             }
////         }];
////    }
//
//    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//
//    NSData*date=UIImageJPEGRepresentation(image, 0.5);
//    UIImage*iii=[UIImage imageWithData:date];
//    //  后期会用到
//    //UIImageView*imageV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iii.size.width, iii.size.height)];
//    //    NSLog(@"%f,%f",iii.size.width,iii.size.height);
//    //[self.view addSubview:imageV];
//    //imageV.image=iii;
//    //    AddPlaceViewController*addCTL=[[AddPlaceViewController alloc] init];
//    //    [self presentViewController:addCTL animated:YES completion:nil];
//
//    MapViewController*mapCTL=[[MapViewController alloc] init];
//
//    mapCTL.mapImage=iii;
////    mapCTL.delegate=self;
//
//    mapCTL.cateryStr=self.cateryStr;
//    mapCTL.singleCityId=self.singleCityId;
//    mapCTL.singleCityName=self.singleCityName;
//
//    [self presentViewController:mapCTL animated:YES completion:nil];
//
//}

@end
