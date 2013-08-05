//
//  UploadViewManager.h
//  AhaTrip
//
//  Created by sohu on 13-8-5.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleMenuViewController.h"
#import "AllMenuViewController.h"
#import "SouSuoViewController.h"

@interface UploadViewControllerManager : UINavigationController<SingleMenuViewDelegate,AllMenuViewDeletage>
{
    PicUploadCateroy _cateroyId;
    NSDictionary * _subCateroyInfo;
}

- (id)initWithCateroyId:(PicUploadCateroy)cateroyId;

@end
