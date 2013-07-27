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
    showPickerButton.frame = CGRectMake(round(self.view.frame.size.width / 2.0-100), self.view.frame.size.height - 350, 200.0, 200.0);
    [showPickerButton setTitle:@"添加图片" forState:UIControlStateNormal];
	showPickerButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [showPickerButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [showPickerButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [self.view addSubview:showPickerButton];
    
	
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 30)];
    Accombodation.text=@"添加图片";
    Accombodation.font=[UIFont systemFontOfSize:18];
    Accombodation.textColor=[UIColor whiteColor];
    Accombodation.backgroundColor=[UIColor clearColor];
    [navView addSubview:Accombodation];
    
    
    //    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44,320, 44)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10, self.view.frame.size.height-44, 50, 44)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];


    UIButton*mainBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [mainBtn setFrame:CGRectMake(280, self.view.frame.size.height-44, 50, 44)];
    mainBtn.contentMode=UIViewContentModeScaleAspectFit;
    [mainBtn setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
    [mainBtn addTarget:self action:@selector(mainBtnMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainBtn];


}
//返回主页
-(void)mainBtnMenu{

   PlazeViewController*centerCTL=[[PlazeViewController alloc] init];
    [self presentViewController:centerCTL animated:YES completion:nil];


}
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
//    if (info) {
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library writeImageDataToSavedPhotosAlbum:[info objectForKey:@"data"] metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
//         {
//             if (error) {
//                 NSLog(@"ERROR: the image failed to be written");
//             }
//             else {
//                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
//             }
//         }];
//    }
//}

-(void) viewDidUnload {
    [super viewDidUnload];
    showPickerButton = nil;
}
@end
