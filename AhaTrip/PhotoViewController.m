//
//  PhotoViewController.m
//  DLCImagePickerController
//
//  Created by Dmitri Cherniak on 8/18/12.
//  Copyright (c) 2012 Backspaces Inc. All rights reserved.
//

#import "PhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Constants.h"
#import "MapViewController.h"
//#import "CenterViewController.h"
#import "PlazeViewController.h"
@interface PhotoViewController ()

@end

@implementation PhotoViewController

@synthesize showPickerButton;
@synthesize  singleCityId,singleCityName,cateryStr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor=mRGBColor(236, 235, 235);
    //    topbar
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];
    
    showPickerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showPickerButton.frame = CGRectMake(round(self.view.frame.size.width / 2.0-75), self.view.frame.size.height - 350,150, 111);
    [showPickerButton setImage:[UIImage imageNamed:@"FromCamera.png"] forState:UIControlStateNormal];
	showPickerButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [showPickerButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [showPickerButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [self.view addSubview:showPickerButton];
    
	
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(15,7, 150, 30)];
    Accombodation.text=@"添加图片";
    Accombodation.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    Accombodation.textColor=[UIColor whiteColor];
    Accombodation.backgroundColor=[UIColor clearColor];
    [navView addSubview:Accombodation];
    
    if ([self isIphone5]) {
        height=548;
    }else{
        height=460;
    
    }
    
    //    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0,height-55,320, 55)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10,height-40, 33, 33)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];


//    UIButton*mainBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [mainBtn setFrame:CGRectMake(280, self.view.frame.size.height-44, 50, 44)];
//    mainBtn.contentMode=UIViewContentModeScaleAspectFit;
//    [mainBtn setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
//    [mainBtn addTarget:self action:@selector(mainBtnMenu) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:mainBtn];


}
////返回主页
//-(void)mainBtnMenu{
//
//   PlazeViewController*centerCTL=[[PlazeViewController alloc] init];
//    [self presentViewController:centerCTL animated:YES completion:nil];
//
//
//}
//返回选择国家列表页

-(void)closeBtnBackMenu{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) takePhoto:(id)sender{
    DLCImagePickerController *picker = [[DLCImagePickerController alloc] init];
    picker.delegate = self;
    picker.singleCityId=self.singleCityId;
    picker.singleCityName=self.singleCityName;
    picker.cateryStr=self.cateryStr;
    
    [self presentModalViewController:picker animated:YES];
}


-(void) imagePickerControllerDidCancel:(DLCImagePickerController *)picker{
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

-(void) viewDidUnload {
    [super viewDidUnload];
    showPickerButton = nil;
}
@end
