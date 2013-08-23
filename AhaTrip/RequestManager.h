//
//  RequestManager.h
//  AhaTrip
//
//  Created by sohu on 13-7-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLLibirary.h"
#import "JSON.h"
@interface RequestManager : NSObject

//账号系统
+ (void)loingWithUserName:(NSString *)name passpord:(NSString*)passpord success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

+ (void)registerWithEmail:(NSString *)mail UserName:(NSString *)name passpord:(NSString *)passpord isGril:(NSInteger)isGirl portrait:(UIImage *)image birthday:(NSString*)brithday success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//修改个人信息
+ (void)updateUserInfoWithName:(NSString *)name des:(NSString *)des birthday:(NSString*)brithday isGril:(NSInteger)isGirl portrait:(UIImage *)image success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//上传接口
+ (void)uploadPics:(NSArray *)picArray withCountryId:(NSInteger)countryId city_id:(NSInteger)cityId category_id:(NSInteger)category_id sub_category_id:(NSInteger)sub_category_id  position:(NSString *)location  description:(NSString *)description business_hours_start:(NSString *)business_hours_start  business_hours_end:(NSString *)business_hours_end price:(NSInteger)price price_unit_id:(NSInteger)price_unit_id hasWifi:(BOOL)hasWifi success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//广场接口
+ (void)getPlazaWithstart:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
//分类的广场接口
+ (void)getPlazaWithCountryId:(int)countryId cityId:(int)cityId cateroy:(PicUploadCateroy)cateroy start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//图片详情页
+ (void)getTitleImagesWithId:(NSString *)titleId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//用户信息
+ (void)getUserInfoWithUserId:(NSString *)userId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//用户finds
+ (void)getFindsUserId:(NSString *)userId Withstart:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//用户favarite
+ (void)getFavUserId:(NSString *)userId Withstart:(NSInteger)start count:(NSInteger)count  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//国家列表
+ (void)getCountryListWithstart:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)getCountryAllListForSeletedWithstart:(NSInteger)start count:(NSInteger)count success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
//城市列表
+ (void)getCityListFromCounty:(NSInteger)country start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//获取所有的cateroy类别
+ (void)getAllCateroyWithToke:(NSString *)token  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//获取2级的cateroy列表
+ (void)getSubCateroyWithToken:(NSString *)token WithCateroy_Id:(NSInteger)cateroyId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//获取价格单位
+ (void)getUintWithSuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;


//评论列表
+ (void)getCommentWithFindingId:(NSInteger)findId start:(NSInteger)start count:(NSInteger)count  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)postComment:(NSString *)comment WithFindingId:(NSInteger)findingId withCommentFatherId:(NSInteger )fatherid success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//喜欢
+ (void)likeWithFindingId:(NSInteger)findingsId  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//GooglePlaces
+ (void)getGooglePlaceWithRadius:(CGFloat)radius latitude:(CGFloat)lat longitude:(CGFloat)lon placeType:(NSString *)type placeContainName:(NSString *)name success:(void (^) (NSData * data))success  failure:(void (^) (NSString * error))failure;

//通知列表
+ (void)getNotificationListSuccess:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
@end
