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

+ (void)registerWithUserName:(NSString *)name passpord:(NSString *)passpord gender:(NSString *)gender portrait:(NSData*)imagedata birthday:(NSString*)brithday success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//广场接口
+ (void)getPlazaWithstart:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
//分类的广场接口
+ (void)getPlazaWithCountryId:(int)countryId cityId:(int)cityId cateroy:(PicUploadCateroy)cateroy start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//图片详情页
+ (void)getTitleImagesWithId:(NSString *)titleId token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//用户信息
+ (void)getUserInfoWithUserId:(NSString *)userId token:(NSString*)token  success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//用户finds
+ (void)getFindsUserId:(NSString *)userId Withstart:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//用户favarite
+ (void)getFavUserId:(NSString *)userId Withstart:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//国家列表
+ (void)getCountryListWithstart:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
//城市列表
+ (void)getCityListFromCounty:(NSInteger)country start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//评论列表
+ (void)getCommentWithFindingId:(NSInteger)findId start:(NSInteger)start count:(NSInteger)count token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
+ (void)postComment:(NSString *)comment WithFindingId:(NSInteger)findingId token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;

//喜欢
+ (void)likeWithFindingId:(NSInteger)findingsId token:(NSString *)token success:(void (^) (NSString * response))success  failure:(void (^) (NSString * error))failure;
@end
