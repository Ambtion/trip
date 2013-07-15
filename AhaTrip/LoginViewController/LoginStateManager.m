//
//  SCPLoginPridictive.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginStateManager.h"
#import "ASIDownloadCache.h"

#define USER_ID             [NSString stringWithFormat:@"__USER_ID__%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]
#define DEVICE_TOKEN        @"__device_token__"
#define LASTUSERNAME        @"__last_usrName__"
#define USER_TOKEN          @"__USER_TOKEN__"
#define REFRESH_TOKEN       @"__REFRESH_TOKEN__"
#define SINA_TOKEN          @"__SINA_TOKEN__"
#define QQ_TOKEN            @"__QQ_TOKEN__"


@implementation CacheManager
+ (void)removeAllCache
{
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self removeCacheOfImage];
}
+ (void)removeCacheOfImage
{
    NSFileManager * manager  = [NSFileManager defaultManager];
    NSString * str = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    NSError * error = nil;
    [manager removeItemAtPath:str error:&error];
    [manager createDirectoryAtPath:str withIntermediateDirectories:YES attributes:nil error:NULL];
    //    if (error) NSLog(@"error::%@",error);
}
@end

@implementation LoginStateManager (private)

+ (void)userDefoultStoreValue:(id)value forKey:(id)key
{
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userinfo = [NSMutableDictionary dictionaryWithDictionary:[self valueForUserinfo]];
    if (!userinfo) userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [userinfo setValue:value forKey:key];
    [userDefault setObject:userinfo forKey:[LoginStateManager currentUserId]];
    [userDefault synchronize];
}

+ (NSDictionary *)valueForUserinfo
{
    if (![LoginStateManager isLogin]) return nil;
    return [[[NSUserDefaults standardUserDefaults] objectForKey:[LoginStateManager currentUserId]] copy] ;
}

+ (void)userDefoultRemoveValeuForKey:(NSString *)key
{
    if (!key || [key isEqualToString:@""]) return;
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * userinfo = [NSMutableDictionary dictionaryWithDictionary:[self valueForUserinfo]];
    if (!userinfo) userinfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [userinfo removeObjectForKey:key];
    [userDefault setObject:userinfo forKey:[LoginStateManager currentUserId]];
    [userDefault synchronize];
}
#pragma mark - StoreDefaults
+ (void)storeData:(NSString *)data forKey:(NSString *)key
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    [defults setObject:data forKey:key];
    [defults synchronize];
}

+ (NSString *)dataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * data = [defaults objectForKey:key];
    return data;
}
+ (void)removeDataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
@end

@implementation LoginStateManager

+ (NSString *)lastUserName
{
    return [self dataForKey:LASTUSERNAME];
}
+ (void)storelastName:(NSString *)userName
{
    [self storeData:userName forKey:LASTUSERNAME];
}

+ (BOOL)isLogin
{
//    [self logCache];
    if (![self dataForKey:USER_ID])
        [self changeToPreVersionState];
//    [self logCache];
    return [self dataForKey:USER_ID] != nil;

}
+ (void)changeToPreVersionState
{
   
    NSString * key = [NSString stringWithFormat:@"__USER_ID__%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"BundlePreVersion"]];
    id value = [self dataForKey:key];
    if (value) {
        [self storeData:value forKey:USER_ID];
        [self removeDataForKey:key];
    }
   
}
+ (void)loginUserId:(NSString *)uid withToken:(NSString *)token RefreshToken:(NSString *)refreshToken
{
    [self storeData:uid forKey:USER_ID];
    [self userDefoultStoreValue:token forKey:USER_TOKEN];
    [self userDefoultStoreValue:refreshToken forKey:REFRESH_TOKEN];
}

+ (void)refreshToken:(NSString *)token RefreshToken:(NSString *)refreshToken
{
    [self storeData:token forKey:USER_TOKEN];
    [self storeData:refreshToken forKey:REFRESH_TOKEN];
}
+ (void)logout
{
    [self removeCookie];
    [CacheManager removeAllCache];
    [self removeDataForKey:USER_ID];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOINGOUT object:nil];
}

+ (void)removeCookie
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
}
+ (NSString *)currentUserId
{
    return [self dataForKey:USER_ID];
}

#pragma mark Token
+ (NSString *)currentToken
{
    return [[[self valueForUserinfo] objectForKey:USER_TOKEN] copy];
}
+ (NSString *)refreshToken
{
    return [[[self valueForUserinfo] objectForKey:REFRESH_TOKEN] copy];
}


#pragma mark Sina
+ (BOOL)isSinaBind
{
    return [[self valueForUserinfo] objectForKey:SINA_TOKEN] ? YES:NO;
}
+ (void)storeSinaTokenInfo:(NSDictionary *)info
{
    [self userDefoultStoreValue:info forKey:SINA_TOKEN];
}
+ (NSDictionary *)sinaTokenInfo
{
    return [[self valueForUserinfo] objectForKey:SINA_TOKEN];
}

#pragma mark QQ
+ (BOOL)isQQBing
{
    return [[self valueForUserinfo] objectForKey:QQ_TOKEN]?YES : NO;
}
+ (void)storeQQTokenInfo:(NSDictionary *)info
{
    [self userDefoultStoreValue:info forKey:QQ_TOKEN];
}
+ (NSDictionary *)qqTokenInfo
{
    return [[self valueForUserinfo] objectForKey:QQ_TOKEN];
}

+ (void)unbindAll
{
//    [self unbind:QQShare];
//    [self unbind:RenrenShare];
//    [self unbind:SinaWeiboShare];
}

@end
