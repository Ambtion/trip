//
//  UIViewController+DivideAssett.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"

#define WRITEIMAGE @"WriteImage"

@interface UIViewController (Tips)
- (void)showLoginViewWithMethodNav:(BOOL)isNav withAnimation:(BOOL)animaiton;
- (MBProgressHUD *)waitForMomentsWithTitle:(NSString*)str withView:(UIView *)view;
- (void)stopWaitProgressView:(MBProgressHUD *)view;
- (void)showPopAlerViewRatherThentasView:(BOOL)isPopView WithMes:(NSString *)message;

@end

@interface UIViewController(WriteImage)
- (void)writePicToAlbumWith:(NSString *)imageStr;
@end


@interface UIViewController(IsMine)
- (BOOL)isMineWithOwnerId:(NSString *)ownerID;
@end


@interface UIImageView(Blur)
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
@end

@interface UIViewController(timeFormat)
- (NSString *)stringFromdate:(NSDate *)date;
@end