//
//  RequestManager.h
//  AhaTrip
//
//  Created by sohu on 13-7-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLLibirary.h"

@interface RequestManager : NSObject
//账号系统
+ (void)loingWithUserName:(NSString *)name passpord:(NSString*)passpord success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

+ (void)registerWithUserName:(NSString *)name passpord:(NSString *)passpord gender:(NSString *)gender portrait:(NSData*)imagedata birthday:(NSString*)brithday success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;


@end
