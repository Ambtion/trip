//
//  AppDelegate.h
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegateOauthor.h"

@interface AppDelegate : AppDelegateOauthor <UIApplicationDelegate>

@property (strong, nonatomic) ALAssetsLibrary * lib;
@property (strong, nonatomic) UIWindow *window;
- (ALAssetsLibrary *)appDefaultAssetLib;
@end
