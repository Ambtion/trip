//
//  Projectconfig.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-11.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "IIViewDeckController.h"

#define ___DEBUG 1

#ifndef PROJECTCONFIG
#define PROJECTCONFIG

#ifdef ___DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif


#endif




