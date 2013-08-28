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
        NSDictionary * dic = [weakSelf.responseString JSONValue];
        DLog(@"%@",dic);
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
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/login/?username=%@&password=%@",name,passpord];
    DLog(@"%@",str);
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

+ (void)registerWithEmail:(NSString *)mail UserName:(NSString *)name passpord:(NSString *)passpord isGril:(NSInteger)isGirl portrait:(UIImage *)image birthday:(NSString*)brithday success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/register"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:mail forKey:@"email"];
    [dic setValue:name forKey:@"username"];
    [dic setValue:passpord forKey:@"password"];
    if (isGirl == 1) {
        [dic setValue:@"female" forKey:@"sex"];
    }else if(isGirl == 0){
        [dic setValue:@"male" forKey:@"sex"];
    }
    if (brithday)
        [dic setValue:brithday forKey:@"birth"];
    DLog(@"%@",dic);
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setStringEncoding:NSUTF8StringEncoding];
    for (id key in [dic allKeys])
        [request setPostValue:[dic objectForKey:key] forKey:key];
    if (image)
        [request setData:UIImageJPEGRepresentation(image, 0.5) forKey:@"photo"];
        __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        DLog(@"%@",weakSelf.responseString);
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
        [request startSynchronous];
}

//修改个人信息
+ (void)updateUserInfoWithName:(NSString *)name des:(NSString *)des birthday:(NSString*)brithday isGril:(NSInteger)isGirl portrait:(UIImage *)image success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/avatarUpdate"];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setPostValue:name forKey:@"username"];
    [request setPostValue:des forKey:@"signature"];
    [request setPostValue:brithday forKey:@"birth"];
    if (isGirl == 1) {
        [request setPostValue:@"female" forKey:@"sex"];
    }else if(isGirl == 0){
        [request setPostValue:@"male" forKey:@"sex"];
    }
    [request setPostValue:[LoginStateManager currentToken] forKey:@"token"];
    [request setData:UIImageJPEGRepresentation(image, 0.5) forKey:@"photo"];
    
    __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        DLog(@"%@",[weakSelf.responseString JSONValue]);
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
    [request startSynchronous];

}

//上传接口
+ (void)uploadPics:(NSArray *)picArray withCountryId:(NSInteger)countryId city_id:(NSInteger)cityId category_id:(NSInteger)category_id sub_category_id:(NSInteger)sub_category_id  position:(NSString *)location  description:(NSString *)description business_hours_start:(NSString *)business_hours_start  business_hours_end:(NSString *)business_hours_end price:(NSInteger)price price_unit_id:(NSInteger)price_unit_id hasWifi:(BOOL)hasWifi success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{

    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/findingCreate"];
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:str]];
    [request setTimeOutSeconds:TIMEOUT];
    [request setStringEncoding:NSUTF8StringEncoding];
    
    //图片
    for (int i = 0; i < picArray.count; i++) {
        NSDictionary * dic = [picArray objectAtIndex:i];
        UIImage * image = [dic objectForKey:@"Image"];
        NSData * data = UIImageJPEGRepresentation(image, 0.5f);
        [request setData:data forKey:[@"photo" stringByAppendingFormat:@"%d",i]];
    }
    [request setPostValue:[NSNumber numberWithInteger:countryId] forKey:@"country_id"];
    [request setPostValue:[NSNumber numberWithInt:cityId] forKey:@"city_id"];
    [request setPostValue:[NSNumber numberWithInt:category_id+1] forKey:@"category_id"];
    [request setPostValue:[NSNumber numberWithInt:sub_category_id] forKey:@"sub_category_id"];
    if (description && ![description isEqualToString:@""])
        [request setPostValue: description forKey:@"description"];
    if (location)
        [request setPostValue: location forKey:@"location"];
    if (business_hours_end && business_hours_start) {
        [request setPostValue: business_hours_start forKey:@"business_hours_start"];
        [request setPostValue: business_hours_end forKey:@"business_hours_end"];
    }
    if (price && price_unit_id ) {
        [request setPostValue: [NSNumber numberWithInt:price] forKey:@"price"];
        [request setPostValue: [NSNumber numberWithInt:price_unit_id] forKey:@"price_unit_id"];
    }
    [request setPostValue: [NSNumber numberWithBool:hasWifi] forKey:@"wifi"];
    [request setPostValue: [LoginStateManager currentToken] forKey:@"token"];
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
    [request startSynchronous];
}

//分享到sina
+ (void)sharePhoto:(UIImage*)image ToQQwithDes:(NSString *)des compressionQuality:(CGFloat)compress  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://graph.qq.com/photo/upload_pic"]];
    [request setPostValue:[[LoginStateManager getTokenInfo:QQShare] objectForKey:@"access_token"] forKey:@"access_token"];
    [request setPostValue:QQAPPID forKey:@"oauth_consumer_key"];
    [request setPostValue:[[LoginStateManager getTokenInfo:QQShare] objectForKey:@"openid"] forKey:@"openid"];
    [request setPostValue:@1 forKey:@"mobile"];
    [request setPostValue:des forKey:@"photodesc"];
    NSData * data = UIImageJPEGRepresentation(image, compress);
    [request setData:data forKey:@"picture"];
    __weak ASIFormDataRequest * weakSelf = request;
    
    [request setCompletionBlock:^{
        NSInteger ret = [[[[weakSelf responseString] JSONValue] objectForKey:@"ret"] integerValue];
        if (!ret) {
            success(nil);
        }else if( (ret>= 100013 && ret >= 100016) || ret == 9016 ||
                 ret == 9017 || ret == 9018 || ret == 9094 || ret == 41003){
            failure(@"token失效,请重新认证");
        }else{
            failure(@"分享失败");
        }
    }];
    [request setFailedBlock:^{
        failure(@"连接失败,请重新分享");
    }];
    [request startAsynchronous];
    
}

+ (void)sharePhoto:(UIImage*)image ToSinawithDes:(NSString *)des compressionQuality:(CGFloat)compress  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    __block ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://upload.api.weibo.com/2/statuses/upload.json"]];
    [request setPostValue:[[LoginStateManager getTokenInfo:SinaWeiboShare] objectForKey:@"access_token"] forKey:@"access_token"];
    if (!des || [des isEqualToString:@""])  des = @"#AhaTrip#";
    [request setPostValue:des forKey:@"status"];
    [request setPostValue:@0 forKey:@"visible"];
    NSData * data  = UIImageJPEGRepresentation(image, compress);
    [request setData:data forKey:@"pic"];
    __weak ASIFormDataRequest * weakSelf = request;
    [request setCompletionBlock:^{
        NSDictionary * dic = [[weakSelf responseString] JSONValue];
        NSNumber *errorCode = [dic objectForKey:@"error_code"];
        if (!errorCode) {
            success(nil);
        }else{
            NSInteger code = [errorCode integerValue];
            if ((code >= 21314 && code <= 21319 )|| code == 21327 || code == 21332) {
                failure(@"token失效,请重新认证");
            }else{
                failure(@"分享失败");
            }
        }
    }];
    [request setFailedBlock:^{
        failure(@"连接失败,请重新分享");
    }];
    [request startAsynchronous];
    
}

//广场接口
+ (void)getPlazaWithstart:(NSInteger)start count:(NSInteger)count  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    //防止未登录状况
    NSString * url = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/index?token=tRyW4rLBiJHffQ&start=%d&count=%d",start,count];
    [self getSourceWithStringUrl:url asynchronou:YES success:success failure:failure];
}



//分类的广场接口
+ (void)getPlazaWithCountryId:(int)countryId cityId:(int)cityId cateroy:(PicUploadCateroy)cateroy start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = nil;
    if (cityId == ALLID && countryId == ALLID) {
        str =  [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/totalIndex?category_id=%d$start=%d&count=%d&token=%@",cateroy == KCateroyAll ? -1 : cateroy + 1,start,count,[LoginStateManager currentToken]];
    }else if (cityId == ALLID){
          str =  [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/totalIndex?country_id=%d&category_id=%d$start=%d&count=%d&token=%@",countryId,cateroy == KCateroyAll ? -1 : cateroy + 1,start,count,[LoginStateManager currentToken]];
    } else{
        str  = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/cityIndex?city_id=%d&category_id=%d&type=search&start=%d&count=%d&token=%@",cityId,cateroy == KCateroyAll ? -1 : cateroy + 1,start,count,[LoginStateManager currentToken]];
    }
    DLog(@"%@",str);
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}


//删除finds
+ (void)deleteFindsWithId:(NSInteger)find_Id success:(void (^) (NSString * response))success failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/findingDelete?finding_id=%d&token=%@",find_Id,[LoginStateManager currentToken]];
    [self postWithURL:str body:nil success:success failure:failure];
//    http://www.myahatrip.com/api/findingDelete?finding_id=42&token=tRyW4rLBiJHffQ
    
}
+ (void)getTitleImagesWithId:(NSString *)titleId success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString* url = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/finding?id=%@&token=%@",titleId,[LoginStateManager currentToken]];
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
    DLog(@"%@",str);
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
+ (void)getCountryAllListForSeletedWithstart:(NSInteger)start count:(NSInteger)count  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/countryList?token=%@&start=%d&count=%d",[LoginStateManager currentToken],start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
//城市列表
+ (void)getAllCityListFromCounty:(NSInteger)country start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/cityList?country_id=%d&token=%@&start=%d&count=%d",country,[LoginStateManager currentToken],start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

+ (void)getCityListFromCounty:(NSInteger)country start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/cityList?country_id=%d&type=search&token=%@&start=%d&count=%d",country,[LoginStateManager currentToken],start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}



//获取所有的cateroy类别
+ (void)getAllCateroyWithToke:(NSString *)token  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/categoryList?token=%@",[LoginStateManager currentToken]];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//获取2级的cateroy列表
+ (void)getSubCateroyWithToken:(NSString *)token WithCateroy_Id:(NSInteger)cateroyId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString* str =[NSString stringWithFormat:@"http://yyz.ahatrip.info/api/subCategoryList?category_id=%d&token=%@",cateroyId,[LoginStateManager currentToken]];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//获取价格单位
+ (void)getUintWithSuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/priceUnitList?token=%@",[LoginStateManager currentToken]];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}

//评论列表
+ (void)getCommentWithFindingId:(NSInteger)findingId start:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/commentList?finding_id=%d&token=%@&start=%d&count=%d",findingId,[LoginStateManager currentToken],start,count];
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
+ (void)postComment:(NSString *)comment WithFindingId:(NSInteger)findingId withCommentFatherId:(NSInteger )fatherid success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure
{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/commentCreate"];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[NSNumber numberWithInteger:findingId] forKey:@"finding_id"];
    [dic setObject:[LoginStateManager currentToken] forKey:@"token"];
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

//通知列表
+ (void)getNotificationListSuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure

{
    NSString * str = [NSString stringWithFormat:@"http://yyz.ahatrip.info/api/messageList?token=%@",[LoginStateManager currentToken]];
    DLog(@"%@",str);
    [self getSourceWithStringUrl:str asynchronou:YES success:success failure:failure];
}
@end
