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
//http://yyz.ahatrip.info/api/login/?username=test&password=123456
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/login/?username=%@&password=%@",name,passpord];
    DLog(@"%@",str);
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

+ (void)registerWithEmail:(NSString *)mail UserName:(NSString *)name passpord:(NSString *)passpord gender:(NSString *)gender portrait:(NSData*)imagedata birthday:(NSString*)brithday success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    //http://yyz.ahatrip.info/api/register
//email: 'yueanzhao@gmail.com'
//username: '老罗'
//    password
//sex: 'male' 'female' 'none'
//birth: '1984-02-14'
//signature: '我的签名'
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/register"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:mail forKey:@"email"];
    [dic setValue:name forKey:@"username"];
    [dic setValue:passpord forKey:@"password"];
    [dic setValue:gender forKey:@"sex"];
    [dic setValue:brithday forKey:@"birth"];
//    [self postWithURL:str body:dic success:success failure:failure];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setStringEncoding:NSUTF8StringEncoding];
    for (id key in [dic allKeys])
        [request setPostValue:[dic objectForKey:key] forKey:key];
    [request setData:imagedata forKey:@"file"];
    [request setData:imagedata forKey:@"file1"];
    [request setData:imagedata forKey:@"file2"];

//    [request setData:imagedata withFileName:@"file" andContentType:@"image/jpeg" forKey:@"file"];
    __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        DLog(@"%@",weakSelf.responseString);
//        if (weakSelf.responseStatusCode == 200){
//            success(weakSelf.responseString);
//        }else{
//            failure([weakSelf.error description]);
//        }
        
    }];
    [request setFailedBlock:^{
        failure([weakSelf.error description]);
        DLog(@"failturl :%@ :%d %@",weakSelf.url,[weakSelf responseStatusCode],[weakSelf responseString]);
    }];
        [request startSynchronous];
}

//广场接口
+ (void)getPlazaWithstart:(NSInteger)start count:(NSInteger)count  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{

    NSString * url = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/index?token=tRyW4rLBiJHffQ&start=%d&count=%d",start,count];
    [self getSourceWithStringUrl:url asynchronou:YES success:success failure:failure];
}

//分类的广场接口
+ (void)getPlazaWithCountryId:(int)countryId cityId:(int)cityId cateroy:(PicUploadCateroy)cateroy start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = nil;
    if (cityId < 0) {
        str =  [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/totalIndex?category_id=%d$start=%d&count=%d&token=tRyW4rLBiJHffQ",cateroy == KCateroyAll ? -1 : cateroy + 1,start,count];
    }else{
        str  = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/cityIndex?city_id=%d&category_id=%d&start=%d&count=%d&token=tRyW4rLBiJHffQ",cityId,cateroy == KCateroyAll ? -1 : cateroy + 1,start,count];
    }
    DLog(@"%@",str);
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

+ (void)getTitleImagesWithId:(NSString *)titleId success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString* url = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/finding?id=%@&token=tRyW4rLBiJHffQ",titleId];
    [self getSourceWithStringUrl:url asynchronou:YES success:success failure:failure];
}

//用户信息
+ (void)getUserInfoWithUserId:(NSString *)userId   success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    NSString * url = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/user?uid=%@&token=%@",userId,[LoginStateManager currentToken]];
    DLog(@"%@",url);
    [self getSourceWithStringUrl:url asynchronou:YES success:success failure:failure];
}

//用户finds
+ (void)getFindsUserId:(NSString *)userId Withstart:(NSInteger)start count:(NSInteger)count  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/userFinding?uid=%@&start=%d&count=%d&token=%@",userId,start,count,[LoginStateManager currentToken]];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//用户favarite
+ (void)getFavUserId:(NSString *)userId Withstart:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/userFavorite?uid=%@&start=%d&count=%d&token=%@",userId,start,count,[LoginStateManager currentToken]];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//国家列表
+ (void)getCountryListWithstart:(NSInteger)start count:(NSInteger)count  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    //有内容的地区
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/countryList?type=search&token=%@&start=%d&count=%d",[LoginStateManager currentToken],start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
+ (void)getCountryAllListForSeletedWithstart:(NSInteger)start count:(NSInteger)count  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/countryList?token=%@&start=%d&count=%d",[LoginStateManager currentToken],start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
//城市列表
+ (void)getCityListFromCounty:(NSInteger)country start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/cityList?country_id=%d&token=tRyW4rLBiJHffQ&start=%d&count=%d",country,start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//获取所有的cateroy类别
+ (void)getAllCateroyWithToke:(NSString *)token  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = @"http://yyz.ahatrip.info/api/categoryList?token=tRyW4rLBiJHffQ";
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//获取2级的cateroy列表
+ (void)getSubCateroyWithToken:(NSString *)token WithCateroy_Id:(NSInteger)cateroyId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString* str =[NSString stringWithFormat:@"http://yyz.ahatrip.info/api/subCategoryList?category_id=%d&token=tRyW4rLBiJHffQ",cateroyId];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//获取价格单位
+ (void)getUintWithSuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
//http://yyz.ahatrip.info/api/priceUnitList?token=tRyW4rLBiJHffQ
    NSString * str = @"http://yyz.ahatrip.info/api/priceUnitList?token=tRyW4rLBiJHffQ";
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//评论列表
+ (void)getCommentWithFindingId:(NSInteger)findingId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/commentList?finding_id=%d&token=%@&start=%d&count=%d",findingId,@"tRyW4rLBiJHffQ",start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
+ (void)postComment:(NSString *)comment WithFindingId:(NSInteger)findingId withCommentFatherId:(NSInteger )fatherid success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/commentCreate"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[NSNumber numberWithInteger:findingId] forKey:@"finding_id"];
    [dic setObject:@"tRyW4rLBiJHffQ" forKey:@"token"];
    [dic setObject:[NSNumber numberWithInt:fatherid] forKey:@"parent_id"];
    [dic setObject:comment forKey:@"content"];
    DLog(@"%@",str);
    DLog(@"%@",dic);
    [self postWithURL:str body:dic success:success failure:failure];
}

//喜欢
+ (void)likeWithFindingId:(NSInteger)findingsId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/favoriteCreate"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[NSNumber numberWithInteger:findingsId] forKey:@"finding_id"];
    [dic setObject:[LoginStateManager currentToken] forKey:@"token"];
    DLog(@"%@",str);
    [self postWithURL:str body:dic success:success failure:failure];
}


#pragma mark - GoogleApi
//Google Places Api Type:https://developers.google.com/places/documentation/supported_types

#define PlaceURLString @"https://maps.googleapis.com/maps/api/place/search/xml?location=%f,%f&radius=%f&types=%@&name=%@&sensor=true&key=AIzaSyBHvxjcnxJNzgukGhgtO65qyxV5aX7DXvg&language=zh-CN"   //key 需自己在google api申请替换

+ (void)getGooglePlaceWithRadius:(CGFloat)radius latitude:(CGFloat)lat longitude:(CGFloat)lon placeType:(NSString *)type placeContainName:(NSString *)name success:(void (^) (NSData * data))success  failure:(void (^) (NSString * error))failure
{

    NSString * strUrl = [NSString stringWithFormat:PlaceURLString,lat,lon,radius,type,name];
    NSURL * googlePlacesURL = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:googlePlacesURL];
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]]; //开启缓冲
    [request setCachePolicy:ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:TIMEOUT];
    [request setStringEncoding:NSUTF8StringEncoding];
    __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        if (weakSelf.responseStatusCode == 200){
            success(weakSelf.responseData);
        }else{
            failure([weakSelf.error description]);
        }
        
    }];
    [request setFailedBlock:^{
        failure([weakSelf.error description]);
        DLog(@"failturl :%@ :%d %@",weakSelf.url,[weakSelf responseStatusCode],[weakSelf responseString]);
    }];
    [request startAsynchronous];
}
@end
