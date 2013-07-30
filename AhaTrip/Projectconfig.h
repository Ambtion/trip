//
//  Projectconfig.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-11.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "LoginStateManager.h"
#import "IIViewDeckController.h"
#import "UIViewController+Method.h"
#import "AppDelegate.h"
#import "RequestManager.h"

#define BASECOLOR [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f]


#define ___DEBUG 1

#ifndef PROJECTCONFIG
#define PROJECTCONFIG

#ifdef ___DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif


#endif




