//
//  PhotoViewController.h
//  DLCImagePickerController
//
//  Created by Dmitri Cherniak on 8/18/12.
//  Copyright (c) 2012 Backspaces Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCImagePickerController.h"
enum __KbuttonTagOpenView{
    KbuttonTagOpenCamera = 100,
    KbuttonTagOpenAssetsLib = 200
};
typedef enum __KbuttonTagOpenView KbuttonTagOpenView;


@protocol SeletedPhotoMethodDelegate <NSObject>
- (void)seletedPhotoMethodControllerDidClickOpneView:(UIButton *)button;
@end
@interface SeletedPhotoMethodController : UIViewController<DLCImagePickerDelegate>

@property(assign,nonatomic)id<SeletedPhotoMethodDelegate>delegate;
@end
