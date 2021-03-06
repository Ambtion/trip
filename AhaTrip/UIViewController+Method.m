//
//  UIViewController+DivideAssett.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "UIViewController+Method.h"
#import <Accelerate/Accelerate.h>
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "ToastAlertView.h"
#import "LoginViewController.h"

@implementation UIViewController(Tips)
- (void)showLoginViewWithMethodNav:(BOOL)isNav withAnimation:(BOOL)animaiton
{
    LoginViewController * loginView = [[LoginViewController alloc] init];
    loginView.delegate = (UIViewController<LoginViewControllerDelegate> *)self;
    if (isNav) {
        [self.navigationController pushViewController:loginView animated:animaiton];
    }else{
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginView];
        [nav.navigationBar setHidden:YES];
        [self presentModalViewController:nav animated:animaiton];
    }
}
#pragma alertView
- (MBProgressHUD *)waitForMomentsWithTitle:(NSString*)str withView:(UIView *)view
{
    if (!view) {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    MBProgressHUD * progressView = [[MBProgressHUD alloc] initWithView:view];
    progressView.animationType = MBProgressHUDAnimationZoomOut;
    progressView.labelText = str;
    [view addSubview:progressView];
    [progressView show:YES];
    return progressView;
}
-(void)stopWaitProgressView:(MBProgressHUD *)view
{
    if (view){
        [view removeFromSuperview];
    }
    else{
        for (UIView * view in self.view.subviews) {
            if ([view isKindOfClass:[MBProgressHUD class]]) {
                [view removeFromSuperview];
            }
        }
        for (UIView * view in [[[UIApplication sharedApplication] delegate] window].subviews) {
            if ([view isKindOfClass:[MBProgressHUD class]]) {
                [view removeFromSuperview];
            }
        }
    }
        
}
- (void)showPopAlerViewWithMes:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate cancelButton:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    UIAlertView * popA = [[UIAlertView alloc] initWithTitle:nil message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherButtonTitles, nil];
    [popA show];
}
- (void)showTotasViewWithMes:(NSString *)message
{
    ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:message];
    [alertView show];
}
- (void)showPopAlerViewWithMes:(NSString *)message
{
    [self showPopAlerViewWithMes:message withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
}
@end

@implementation UIViewController(WriteImage)

- (void)writePicToAlbumWith:(NSString *)imageStr
{
    [self waitForMomentsWithTitle:@"保存到本地..." withView:self.view];
    UIImageView * view = [[UIImageView alloc] init];
    [view setImageWithURL:[NSURL URLWithString:imageStr] success:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    } failure:^(NSError *error) {
        [self stopWaitProgressView:nil];
        [self showTotasViewWithMes:@"保存失败"];
    }];
}
- (void)image: (UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo
{
    [self stopWaitProgressView:nil];
    if (error) {
        [self showTotasViewWithMes:@"保存失败"];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:WRITEIMAGE object:nil];
        [self showTotasViewWithMes:@"图片已保存到本地"];
    }
}

@end


@implementation UIViewController(IsMine)
- (BOOL)isMineWithOwnerId:(NSString *)ownerID
{
    return [LoginStateManager isLogin] && [[LoginStateManager currentUserId] isEqualToString:ownerID];
}
- (BOOL)isIphone5
{
    return [[UIScreen mainScreen] bounds].size.height > 480;
}
@end

@implementation UIImageView(Blur)
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end

@implementation UIViewController(timeFormat)
- (NSString *)stringFromdate:(NSDate *)date
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}
@end

@implementation UIViewController(AppDelegate)
- (AppDelegate*)AppDelegate
{
    return [[UIApplication sharedApplication] delegate];
}
- (LeftMenuController *)leftMenuController
{
    return (LeftMenuController *)[[self viewDeckController] leftController];
}
- (void)changeToHome
{
    IIViewDeckController * controll = [[[[self AppDelegate] window] rootViewController].childViewControllers objectAtIndex:0];
    controll.centerController = ((LeftMenuController *)controll.leftController).homeController;
}
@end
//KCateroySight = 0,
//KCateroyShopping = 1,
//KCateroyDinner = 2,
//KCateroyHotel = 3,
//KCateroyDrink = 4,
//KCateroyEntertainment = 5,

@implementation NSObject(Cateroy)
- (NSString *)getCateryImage:(PicUploadCateroy)cateroy
{
    switch (cateroy) {
        case KCateroySight:
            return @"view.png";
            break;
        case KCateroyShopping:
            return @"shopping.png";
            break;
        case KCateroyDinner:
            return @"food.png";
            break;
        case KCateroyHotel:
            return @"hotel.png";
            break;
//        case KCateroyDrink:
//            return @"drink.png";
            break;
        case KCateroyEntertainment:
            return @"Entertainment.png";
            break;
        default:
            return nil;
            break;
    }
}
@end

@implementation NSObject(AssetLib)
- (ALAssetsLibrary *)defaultLib
{
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] appDefaultAssetLib];
}
@end