//
//  PhotoViewController.h
//  DLCImagePickerController
//
//  Created by Dmitri Cherniak on 8/18/12.
//  Copyright (c) 2012 Backspaces Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCImagePickerController.h"

@interface PhotoViewController : UIViewController<DLCImagePickerDelegate>
{

    UIImageView*bottomBar;

}
@property (nonatomic, strong) UIButton *showPickerButton;
@property(nonatomic,strong)NSString*singleCityId;
@property(nonatomic,strong)NSString*singleCityName;
@property(nonatomic,strong)NSString*cateryStr;
@end
