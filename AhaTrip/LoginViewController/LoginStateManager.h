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

typedef enum __shareModel {
    SinaWeiboShare,
    RenrenShare,
    WeixinShare,
    QQShare,
    SohuShare,
    NoShare,
}KShareModel;


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
//+ (NSDictionary *)qqTokenInfo;

+ (BOOL)isRenrenBind;
+ (void)storeRenRenTokenInfo:(NSDictionary *)info;
//+ (NSDictionary *)renrenTokenInfo;

+ (NSDictionary *)getTokenInfo:(KShareModel)model;
+ (void)unbind:(KShareModel)model;

+ (void)storeDeviceID:(NSNumber *)deviceId;
+ (long long)deviceId;

+ (void)storeDeviceToken:(NSString *)deviceToken;
+ (NSString *)deviceToken;

#pragma DeviceToken For Push
+ (BOOL)upDateDeviceToken;
+ (BOOL)deleteDeviceToken;
@end
