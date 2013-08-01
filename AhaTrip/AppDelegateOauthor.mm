//
//  AppDelegateOauthor.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "AppDelegateOauthor.h"

@implementation AppDelegateOauthor
@synthesize sinaweibo,tencentOAuth;

#pragma mark - SINA
- (void)sinaLoginWithDelegate:(id<SinaWeiboDelegate>)delegate
{
    //init Sina
    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:delegate];
    [sinaweibo logIn];
}

- (void)qqregisterWithDelegate:(id<QQApiInterfaceDelegate>)delegate
{
    if (!tencentOAuth)
        tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:nil];
    _qqtempDelegate = delegate;
}

#pragma mark - qq
- (void)qqLoginWithDelegate:(id<TencentSessionDelegate>)delegate
{
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAPPID andDelegate:delegate];
    NSArray * qqPermissions = [NSArray arrayWithObjects:
                                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                kOPEN_PERMISSION_ADD_PIC_T, /** 上传图片并发表消息到腾讯微博 */
                                kOPEN_PERMISSION_UPLOAD_PIC,  /** 上传一张照片到QQ空间相册(<b>需要申请权限</b>) */
                                nil];
	[tencentOAuth authorize:qqPermissions inSafari:NO];
}
#pragma mark AppDelegate FOR SSO

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self ssoReturn:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self ssoReturn:url];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    return [self.sinaweibo applicationDidBecomeActive];
}
- (BOOL)ssoReturn:(NSURL *)url
{
    if ([[url absoluteString] rangeOfString:@"tencent"].location != NSNotFound) {
        return [TencentOAuth HandleOpenURL:url] ;
    }
    if ([[url absoluteString] rangeOfString:@"QQ"].location != NSNotFound) {
        return [QQApiInterface handleOpenURL:url delegate:_qqtempDelegate];
    }
    if ([[url absoluteString] rangeOfString:@"sina"].location != NSNotFound) {
        return [self.sinaweibo handleOpenURL:url];
    }
    return YES;
}
@end
