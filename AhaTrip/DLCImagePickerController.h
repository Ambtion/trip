//
//  DLCImagePickerController.h
//  DLCImagePickerController
//
//  Created by Dmitri Cherniak on 8/14/12.
//  Copyright (c) 2012 Dmitri Cherniak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "BlurOverlayView.h"
#import "MapViewController.h"
@class DLCImagePickerController;

@protocol DLCImagePickerDelegate <NSObject>
@optional
- (void)DLImagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
@end

@interface DLCImagePickerController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate,MapViewDelegate> {
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> * filter;
    GPUImageOutput<GPUImageInput> * blurFilter;
    GPUImageCropFilter *cropFilter;
    GPUImagePicture * staticPicture;
    UIImageOrientation staticPictureOriginalOrientation;
    BOOL isLibModel;
    UIImageView * filterSeletedImageView;
    
}

@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, weak) id <DLCImagePickerDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIButton *photoCaptureButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@property (nonatomic, weak) IBOutlet UIButton *cameraToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *finalOutPutButton;
@property (nonatomic, weak) IBOutlet UIButton *libraryToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *flashToggleButton;
@property (nonatomic, weak) IBOutlet UIButton *retakeButton; //后退按钮

@property (nonatomic, strong) UIScrollView *filterScrollView;
@property (nonatomic, weak) IBOutlet UIView *photoBar;
@property (nonatomic, weak) IBOutlet UIView *topBar;
@property (nonatomic, strong) BlurOverlayView *blurOverlayView;
@property (nonatomic, strong) UIImageView *focusView;

@property (nonatomic, assign) CGFloat outputJPEGQuality;

- (void)switchToLibraryWithAnimaion:(BOOL)animation;

@end
