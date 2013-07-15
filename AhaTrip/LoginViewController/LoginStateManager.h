//
//  SCPLoginPridictive.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

#define  LOINGOUT   @"__LOGINOUNT__"

@interface CacheManager : NSObject
+ (void)removeAllCache;
@end

@interface LoginStateManager : NSObject

+ (BOOL)isLogin;
+ (void)loginUserId:(NSString *)uid withToken:(NSString *)token RefreshToken:(NSString *)refreshToken;
+ (void)refreshToken:(NSString *)token RefreshToken:(NSString *)refreshToken;
+ (void)logout;

+ (NSString *)currentUserId;
+ (NSString *)currentToken;
+ (NSString *)refreshToken;

+ (NSString *)lastUserName;
+ (void)storelastName:(NSString *)userName;

+ (BOOL)isSinaBind;
+ (void)storeSinaTokenInfo:(NSDictionary *)info;
//+ (NSDictionary *)sinaTokenInfo;


+ (BOOL)isQQBing;
+ (void)storeQQTokenInfo:(NSDictionary *)info;

@end
