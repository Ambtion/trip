//
//  RequestManager.m
//  AhaTrip
//
//  Created by sohu on 13-7-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "RequestManager.h"
#import "RequestManager.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"

#define TIMEOUT 10.f

#define REQUSETFAILERROR    @"当前网络不给力,请稍后重试"
#define REQUSETSOURCEFIAL   @"访问的资源不存在"
#define REFRESHFAILTURE     @"登录过期,请重新登录"
#define INVISABLETOKEN      @"token过期,请重新绑定"

@implementation RequestManager(private)

+ (void)getWithUrlStr:(NSString *)strUrl andMethod:(NSString *)method body:(NSDictionary *)body asynchronou:(BOOL)asy success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]]; //开启缓冲
    [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request addRequestHeader:@"accept" value:@"application/json"];
    [request setRequestMethod:method];
    [request setTimeOutSeconds:TIMEOUT];
    [request setStringEncoding:NSUTF8StringEncoding];
    for (id key in [body allKeys])
        [request setPostValue:[body objectForKey:key] forKey:key];
    __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        if (weakSelf.responseStatusCode == 200){
            success(weakSelf.responseString);
        }else{
            failure([weakSelf.error description]);
        }
        
    }];
    [request setFailedBlock:^{
        failure([weakSelf.error description]);
        DLog(@"failturl :%@ :%d %@",weakSelf.url,[weakSelf responseStatusCode],[weakSelf responseString]);
    }];
    if (asy)
        [request startAsynchronous];
    else
        [request startSynchronous];
}

#pragma mark GET
+ (void)getSourceWithStringUrl:(NSString * )strUrl asynchronou:(BOOL)asy success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"GET" body:nil asynchronou:asy success:success failure:failure];
}

#pragma mark POST
+ (void)postWithURL:(NSString *)strUrl body:(NSDictionary *)body success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"POST" body:body asynchronou:YES success:success failure:failure];
}

#pragma mark DELETE
+ (void)deleteSoruce:(NSString * )strUrl success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    [self getWithUrlStr:strUrl andMethod:@"DELETE" body:nil asynchronou:YES success:success failure:failure];
}
@end


@implementation RequestManager
+ (void)loingWithUserName:(NSString *)name passpord:(NSString*)passpord success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
}

+ (void)registerWithUserName:(NSString *)name passpord:(NSString *)passpord gender:(NSString *)gender portrait:(NSData*)imagedata birthday:(NSString*)brithday success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
}

//广场接口
+ (void)getPlazaWithstart:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * url = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/index?token=tRyW4rLBiJHffQ&start=%d&count=%d",start,count];
    [self getSourceWithStringUrl:url asynchronou:YES success:success failure:failure];
}
+ (void)getTitleImagesWithId:(NSString *)titleId token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
//    http://yyz.ahatrip.info/api/finding?id=1&token=tRyW4rLBiJHffQ
    NSString* url = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/finding?id=%@&token=tRyW4rLBiJHffQ",titleId];
    [self getSourceWithStringUrl:url asynchronou:YES success:success failure:failure];
}
@end
