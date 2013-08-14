//
//  DLCImagePickerController.m
//  DLCImagePickerController
//
//  Created by Dmitri Cherniak on 8/14/12.
//  Copyright (c) 2012 Dmitri Cherniak. All rights reserved.
//

#import "DLCImagePickerController.h"
#import "GrayscaleContrastFilter.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AddPlaceViewController.h"
#import "UIImage+Addition.h"
#import <ImageIO/ImageIO.h>
#import "AddPlaceViewController.h"
#import "MapViewController.h"
#import "Constants.h"

#define kStaticBlurSize 2.0f

@implementation DLCImagePickerController {
    BOOL isStatic;
    BOOL hasBlur;
    int selectedFilter;
}

@synthesize delegate,
imageView,
cameraToggleButton,
photoCaptureButton,
blurToggleButton,
flashToggleButton,
cancelButton,
retakeButton,
finalOutPutButton,
libraryToggleButton,
filterScrollView,
filtersBackgroundImageView,
photoBar,
topBar,
blurOverlayView,
outputJPEGQuality;

-(id)init {
    
    self = [super initWithNibName:@"DLCImagePicker" bundle:nil];
    
    if (self) {
        self.outputJPEGQuality = 1.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    //set background color
    self.view.backgroundColor = mRGBColor(43, 43, 44);
    [self.blurToggleButton setSelected:NO];
    self.finalOutPutButton.hidden=YES;
    staticPictureOriginalOrientation = UIImageOrientationUp;
    
    self.focusView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"focus-crosshair"]];
	[self.view addSubview:self.focusView];
	self.focusView.alpha = 0;
    //模糊图层不需要
    //    self.blurOverlayView = [[BlurOverlayView alloc] initWithFrame:CGRectMake(0, 0,
    //                                                                         self.imageView.frame.size.width,
    //                                                                         self.imageView.frame.size.height)];
    //    self.blurOverlayView.alpha = 0;
    //    [self.imageView addSubview:self.blurOverlayView];
    hasBlur = NO;
    [self loadFilters];
    //we need a crop filter for the live video
    cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0f, 0.0f, 1.0f, 0.75)];
    filter = [[GPUImageFilter alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self setUpCamera];
    });
    [self showFilters];
    [self setTabBarButtonToFinal:NO];
}

- (void)setTabBarButtonToFinal:(BOOL)isFinal
{
    self.retakeButton.hidden = !isFinal;
    [self.retakeButton setEnabled:isFinal];
    self.finalOutPutButton.hidden = !isFinal;
    [self.finalOutPutButton setEnabled:isFinal];
    
    self.photoCaptureButton.hidden = isFinal;
    [self.photoCaptureButton setEnabled:!isFinal];
    self.cancelButton.hidden = isFinal;
    self.cancelButton.enabled = !isFinal;
    self.libraryToggleButton.hidden = isFinal;
    self.libraryToggleButton.enabled = !isFinal;
}

-(void) viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [super viewWillAppear:animated];
}

-(void) loadFilters
{
    
    for(int i = 0; i < 9; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i + 1]] forState:UIControlStateNormal];
        button.frame = CGRectMake(10+i*(60+10), 5.0f, 60.0f, 60.0f);
        button.layer.cornerRadius = 7.0f;
        
        //use bezier path instead of maskToBounds on button.layer
        UIBezierPath *bi = [UIBezierPath bezierPathWithRoundedRect:button.bounds
                                                 byRoundingCorners:UIRectCornerAllCorners
                                                       cornerRadii:CGSizeMake(7.0,7.0)];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = button.bounds;
        maskLayer.path = bi.CGPath;
        button.layer.mask = maskLayer;
        
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[UIColor blackColor] CGColor];
        
        [button addTarget:self
                   action:@selector(filterClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button setTitle:@"*" forState:UIControlStateSelected];
        if(i == 0){
            [button setSelected:YES];
        }
		[self.filterScrollView addSubview:button];
	}
	[self.filterScrollView setContentSize:CGSizeMake(10 + 10*(60+10), 75.0)];
}


-(void) setUpCamera
{
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        // Has camera
        
        stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
        
        stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        runOnMainQueueWithoutDeadlocking(^{
            [stillCamera startCameraCapture];
            if([stillCamera.inputCamera hasTorch]){
                [self.flashToggleButton setEnabled:YES];
            }else{
                [self.flashToggleButton setEnabled:NO];
            }
            [self prepareFilter];
        });
    } else {
        // No camera
        NSLog(@"No camera");
        runOnMainQueueWithoutDeadlocking(^{
            [self prepareFilter];
        });
    }
    
}

-(void) filterClicked:(UIButton *) sender
{
    for(UIView *view in self.filterScrollView.subviews){
        if([view isKindOfClass:[UIButton class]]){
            [(UIButton *)view setSelected:NO];
        }
    }
    
    [sender setSelected:YES];
    [self removeAllTargets];
    selectedFilter = sender.tag;
    [self setFilter:sender.tag];
    [self prepareFilter];
}

-(void) setFilter:(int) index
{
    switch (index) {
        case 1:{
            filter = [[GPUImageContrastFilter alloc] init];
            [(GPUImageContrastFilter *) filter setContrast:1.75];
        } break;
        case 2: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess"];
        } break;
        case 3: {
            filter = [[GrayscaleContrastFilter alloc] init];
        } break;
        case 4: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17"];
        } break;
        case 5: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
        } break;
        case 6: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red"];
        } break;
        case 7: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06"];
        } break;
        case 8: {
            filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green"];
        } break;
        default:
            filter = [[GPUImageFilter alloc] init];
            break;
    }
}

-(void) prepareFilter
{
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        isStatic = YES;
    }
    if (!isStatic) {
        [self prepareLiveFilter];
    } else {
        [self prepareStaticFilter];
    }
}

-(void) prepareLiveFilter {
    
    [stillCamera addTarget:cropFilter];
    [cropFilter addTarget:filter];
    //blur is terminal filter
    if (hasBlur) {
        [filter addTarget:blurFilter];
        [blurFilter addTarget:self.imageView];
        //regular filter is terminal
    } else {
        [filter addTarget:self.imageView];
    }
    [filter prepareForImageCapture];
}

-(void) prepareStaticFilter
{
    
    if (!staticPicture) {
        // TODO: fix this hack
        [self performSelector:@selector(switchToLibrary:) withObject:nil afterDelay:0.5];
    }
    [staticPicture addTarget:filter];
    
    // blur is terminal filter
    if (hasBlur) {
        [filter addTarget:blurFilter];
        [blurFilter addTarget:self.imageView];
        //regular filter is terminal
    } else {
        [filter addTarget:self.imageView];
    }
    
    GPUImageRotationMode imageViewRotationMode = kGPUImageNoRotation;
    switch (staticPictureOriginalOrientation) {
        case UIImageOrientationLeft:
            imageViewRotationMode = kGPUImageRotateLeft;
            break;
        case UIImageOrientationRight:
            imageViewRotationMode = kGPUImageRotateRight;
            break;
        case UIImageOrientationDown:
            imageViewRotationMode = kGPUImageRotate180;
            break;
        default:
            imageViewRotationMode = kGPUImageNoRotation;
            break;
    }
    
    // seems like atIndex is ignored by GPUImageView...
    [self.imageView setInputRotation:imageViewRotationMode atIndex:0];
    
    
    [staticPicture processImage];
}

-(void) removeAllTargets
{
    [stillCamera removeAllTargets];
    [staticPicture removeAllTargets];
    [cropFilter removeAllTargets];
    
    //regular filter
    [filter removeAllTargets];
    
    //blur
    [blurFilter removeAllTargets];
}

-(IBAction)switchToLibrary:(id)sender
{
    if (!isStatic) {
        // shut down camera
        [stillCamera stopCameraCapture];
        [self removeAllTargets];
    }
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}
- (void)switchToLibraryWithAnimaion:(BOOL)animation
{
    if (!isStatic) {
        // shut down camera
        [stillCamera stopCameraCapture];
        [self removeAllTargets];
    }
    isLibModel = YES;
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:animation completion:NULL];
}
-(IBAction)toggleFlash:(UIButton *)button
{
    [button setSelected:!button.selected];
}

//-(IBAction) toggleBlur:(UIButton*)blurButton {
//
//    [self.blurToggleButton setEnabled:NO];
//    [self removeAllTargets];
//
//    if (hasBlur) {
//        hasBlur = NO;
//        [self showBlurOverlay:NO];
//        [self.blurToggleButton setSelected:NO];
//    } else {
//        if (!blurFilter) {
//            blurFilter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
//            [(GPUImageGaussianSelectiveBlurFilter*)blurFilter setExcludeCircleRadius:80.0/320.0];
//            [(GPUImageGaussianSelectiveBlurFilter*)blurFilter setExcludeCirclePoint:CGPointMake(0.5f, 0.5f)];
//            [(GPUImageGaussianSelectiveBlurFilter*)blurFilter setBlurSize:kStaticBlurSize];
//            [(GPUImageGaussianSelectiveBlurFilter*)blurFilter setAspectRatio:1.0f];
//        }
//        hasBlur = YES;
//        [self.blurToggleButton setSelected:YES];
//        [self flashBlurOverlay];
//    }
//
//    [self prepareFilter];
//    [self.blurToggleButton setEnabled:YES];
//}

-(IBAction) switchCamera
{
    [self.cameraToggleButton setEnabled:NO];
    [stillCamera rotateCamera];
    [self.cameraToggleButton setEnabled:YES];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && stillCamera) {
        if ([stillCamera.inputCamera hasFlash] && [stillCamera.inputCamera hasTorch]) {
            [self.flashToggleButton setEnabled:YES];
        } else {
            [self.flashToggleButton setEnabled:NO];
        }
    }
}

-(void) prepareForCapture
{
    [stillCamera.inputCamera lockForConfiguration:nil];
    if(self.flashToggleButton.selected &&
       [stillCamera.inputCamera hasTorch]){
        [stillCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
        [self performSelector:@selector(captureImage)
                   withObject:nil
                   afterDelay:0.25];
    }else{
        [self captureImage];
    }
}


-(void)captureImage
{
    UIImage *img = [cropFilter imageFromCurrentlyProcessedOutput];
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, NULL);
    DLog(@"LLLLLLLL:%@",NSStringFromCGSize(img.size));
    [stillCamera.inputCamera unlockForConfiguration];
    [stillCamera stopCameraCapture];
    [self removeAllTargets];
    staticPicture = [[GPUImagePicture alloc] initWithImage:img
                                       smoothlyScaleOutput:YES];
    
    staticPictureOriginalOrientation = img.imageOrientation;
    [self prepareFilter];
    [self setTabBarButtonToFinal:YES];
}

-(IBAction) takePhoto:(id)sender{
    
    [self.photoCaptureButton setEnabled:NO];
    if (!isStatic) {
        isStatic = YES;
        [self prepareForCapture];
    }else
        
    {
        isStatic = NO;
        [self setTabBarButtonToFinal:YES];
    }
}

-(IBAction)retakePhoto:(UIButton *)button
{
    //    [self prepareFilter];
    //    [self showFilters];
    //    [self.retakeButton setHidden:YES];
    //    [self.libraryToggleButton setHidden:NO];
    //    photoCaptureButton.hidden=NO;
    //
    //    cancelButton.hidden=NO;
    //    finalOutPutButton.hidden=YES;
    
    staticPicture = nil;
    staticPictureOriginalOrientation = UIImageOrientationUp;
    isStatic = NO;
    [self removeAllTargets];
    [stillCamera startCameraCapture];
    [self.cameraToggleButton setEnabled:YES];
    
    if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]
       && stillCamera
       && [stillCamera.inputCamera hasTorch]) {
        [self.flashToggleButton setEnabled:YES];
    }
    
    //    [self.photoCaptureButton setImage:[UIImage imageNamed:@"take_photo.png"] forState:UIControlStateNormal];
    //    [self.photoCaptureButton setTitle:nil forState:UIControlStateNormal];
    [self setTabBarButtonToFinal:NO];
    [self setFilter:selectedFilter];
    [self prepareFilter];
    
}

- (IBAction) cancel:(id)sender
{
    
    [self dismissViewControllerAnimated:!isLibModel completion:NULL];
}

-(IBAction) handlePan:(UIGestureRecognizer *) sender
{
    if (hasBlur) {
        //模糊点击..取消了
        CGPoint tapPoint = [sender locationInView:imageView];
        GPUImageGaussianSelectiveBlurFilter* gpu =
        (GPUImageGaussianSelectiveBlurFilter*)blurFilter;
        
        if ([sender state] == UIGestureRecognizerStateBegan) {
            [self showBlurOverlay:YES];
            [gpu setBlurSize:0.0f];
            if (isStatic) {
                [staticPicture processImage];
            }
        }
        
        if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
            [gpu setBlurSize:0.0f];
            [self.blurOverlayView setCircleCenter:tapPoint];
            [gpu setExcludeCirclePoint:CGPointMake(tapPoint.x/320.0f, tapPoint.y/320.0f)];
        }
        
        if([sender state] == UIGestureRecognizerStateEnded){
            [gpu setBlurSize:kStaticBlurSize];
            [self showBlurOverlay:NO];
            if (isStatic) {
                [staticPicture processImage];
            }
        }
    }
}

- (IBAction) handleTapToFocus:(UITapGestureRecognizer *)tgr{
    //聚焦点击
	if (!isStatic && tgr.state == UIGestureRecognizerStateRecognized) {
		CGPoint location = [tgr locationInView:self.imageView];
		AVCaptureDevice *device = stillCamera.inputCamera;
		CGPoint pointOfInterest = CGPointMake(.5f, .5f);
		CGSize frameSize = [[self imageView] frame].size;
		if ([stillCamera cameraPosition] == AVCaptureDevicePositionFront) {
            location.x = frameSize.width - location.x;
		}
		pointOfInterest = CGPointMake(location.y / frameSize.height, 1.f - (location.x / frameSize.width));
		if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            NSError *error;
            if ([device lockForConfiguration:&error]) {
                [device setFocusPointOfInterest:pointOfInterest];
                
                [device setFocusMode:AVCaptureFocusModeAutoFocus];
                
                if([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                    [device setExposurePointOfInterest:pointOfInterest];
                    [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                }
                
                self.focusView.center = [tgr locationInView:self.view];
                self.focusView.alpha = 1;
                
                [UIView animateWithDuration:0.5 delay:0.5 options:0 animations:^{
                    self.focusView.alpha = 0;
                } completion:nil];
                
                [device unlockForConfiguration];
			} else {
                NSLog(@"ERROR = %@", error);
			}
		}
	}
}

-(IBAction) handlePinch:(UIPinchGestureRecognizer *) sender
{
    if (hasBlur) {
        CGPoint midpoint = [sender locationInView:imageView];
        GPUImageGaussianSelectiveBlurFilter* gpu =
        (GPUImageGaussianSelectiveBlurFilter*)blurFilter;
        
        if ([sender state] == UIGestureRecognizerStateBegan) {
            [self showBlurOverlay:YES];
            [gpu setBlurSize:0.0f];
            if (isStatic) {
                [staticPicture processImage];
            }
        }
        
        if ([sender state] == UIGestureRecognizerStateBegan || [sender state] == UIGestureRecognizerStateChanged) {
            [gpu setBlurSize:0.0f];
            [gpu setExcludeCirclePoint:CGPointMake(midpoint.x/320.0f, midpoint.y/320.0f)];
            self.blurOverlayView.circleCenter = CGPointMake(midpoint.x, midpoint.y);
            CGFloat radius = MAX(MIN(sender.scale*[gpu excludeCircleRadius], 0.6f), 0.15f);
            self.blurOverlayView.radius = radius*320.f;
            [gpu setExcludeCircleRadius:radius];
            sender.scale = 1.0f;
        }
        
        if ([sender state] == UIGestureRecognizerStateEnded) {
            [gpu setBlurSize:kStaticBlurSize];
            [self showBlurOverlay:NO];
            if (isStatic) {
                [staticPicture processImage];
            }
        }
    }
}

-(void) showFilters
{
    
    CGRect imageRect = self.imageView.frame;
    CGRect sliderScrollFrame = self.filterScrollView.frame;
    sliderScrollFrame.origin.y -= self.filterScrollView.frame.size.height;
    CGRect sliderScrollFrameBackground = self.filtersBackgroundImageView.frame;
    sliderScrollFrameBackground.origin.y -=
    self.filtersBackgroundImageView.frame.size.height-3;
    
    self.filterScrollView.hidden = NO;
    self.filtersBackgroundImageView.hidden = NO;
    self.filterScrollView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.10
                          delay:0.05
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.imageView.frame = imageRect;
                         self.filterScrollView.frame = sliderScrollFrame;
                         self.filtersBackgroundImageView.frame = sliderScrollFrameBackground;
                     }
                     completion:^(BOOL finished){
                         self.finalOutPutButton.enabled = YES;
                     }];
}

//-(void) hideFilters {
////    [self.filtersToggleButton setSelected:NO];
//    self.filtersToggleButton.hidden=YES;
//    CGRect imageRect = self.imageView.frame;
//    imageRect.origin.y += 34;
//    CGRect sliderScrollFrame = self.filterScrollView.frame;
//    sliderScrollFrame.origin.y += self.filterScrollView.frame.size.height;
//
//    CGRect sliderScrollFrameBackground = self.filtersBackgroundImageView.frame;
//    sliderScrollFrameBackground.origin.y += self.filtersBackgroundImageView.frame.size.height-3;
//
//    [UIView animateWithDuration:0.10
//                          delay:0.05
//                        options: UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         self.imageView.frame = imageRect;
//                         self.filterScrollView.frame = sliderScrollFrame;
//                         self.filtersBackgroundImageView.frame = sliderScrollFrameBackground;
//                     }
//                     completion:^(BOOL finished){
//
//                         self.filtersToggleButton.enabled = YES;
//                         self.filterScrollView.hidden = YES;
//                         self.filtersBackgroundImageView.hidden = YES;
//                     }];
//}

//点击上传图片
-(IBAction) finalOutPutImage:(UIButton *)sender
{
    GPUImageOutput<GPUImageInput> *processUpTo;
    if (hasBlur) {
        processUpTo = blurFilter;
    } else {
        processUpTo = filter;
    }
    [staticPicture processImage];
    
    UIImage *currentFilteredVideoFrame = [processUpTo imageFromCurrentlyProcessedOutputWithOrientation:staticPictureOriginalOrientation];
    NSMutableDictionary * info = [NSMutableDictionary dictionaryWithCapacity:0];
    [info setObject:currentFilteredVideoFrame forKey:@"Image"];
    if ([delegate respondsToSelector:@selector(DLImagePickerController:didFinishPickingMediaWithInfo:)])
        [delegate DLImagePickerController:self didFinishPickingMediaWithInfo:info];
    
}

-(void)mapViewControllerDidCancel:(MapViewController *)picker{
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void) showBlurOverlay:(BOOL)show{
    if(show){
        [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
            self.blurOverlayView.alpha = 0.6;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.35 delay:0.2 options:0 animations:^{
            self.blurOverlayView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(void) flashBlurOverlay {
    [UIView animateWithDuration:0.2 delay:0 options:0 animations:^{
        self.blurOverlayView.alpha = 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 delay:0.2 options:0 animations:^{
            self.blurOverlayView.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void) dealloc {
    
    [self removeAllTargets];
    stillCamera = nil;
    cropFilter = nil;
    filter = nil;
    blurFilter = nil;
    staticPicture = nil;
    self.blurOverlayView = nil;
    self.focusView = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [stillCamera stopCameraCapture];
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* outputImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (outputImage == nil) {
        outputImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (outputImage) {
        staticPicture = [[GPUImagePicture alloc] initWithImage:outputImage smoothlyScaleOutput:YES];
        staticPictureOriginalOrientation = outputImage.imageOrientation;
        isStatic = YES;
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.cameraToggleButton setEnabled:NO];
        [self.flashToggleButton setEnabled:NO];
        [self prepareStaticFilter];
        //        [self.photoCaptureButton setTitle:@"" forState:UIControlStateNormal];
        //        [self.photoCaptureButton setImage:nil forState:UIControlStateNormal];
        //        [self.photoCaptureButton setEnabled:YES];
        [self setTabBarButtonToFinal:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:!isLibModel completion:nil];
    if (isLibModel)
        [self cancel:nil];
    else
        [self retakePhoto:nil];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#endif

@end
