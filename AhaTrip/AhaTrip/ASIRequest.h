//
//  ASIRequest.h
//  嘉德
//
//  Created by tagux imac04 on 13-1-22.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ASIRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

//Wifi环境是为Yes，否则为NO
#define kCanDownloadData        @"canDownloadData"

@interface ASIRequest : NSObject

+ (void)get:(NSString *)url header:(NSDictionary *)header delegate:(id)delegate tag:(NSUInteger)tag;
+ (void)post:(NSString *)url header:(NSDictionary *)header body:(NSDictionary *)body delegate:(id)delegate tag:(NSUInteger)tag;

+ (ASIRequest *)shareInstance;

- (void)get:(NSString *)url header:(NSDictionary *)header delegate:(id)delegate tag:(NSUInteger)tag useCache:(BOOL)useCache;
- (void)post:(NSString *)url header:(NSDictionary *)header body:(NSDictionary *)body delegate:(id)delegate tag:(NSUInteger)tag;

//页面退出时，取消请求
- (void)clearRequestDelegateAndCancel:(ASIHTTPRequest *)request;
- (void)clearAllRequestDelegateAndCancel;

//- (void)clearAllDelegate;

//阶列请求
- (void)addQueueToTarget:(id)target finishedSelector:(SEL)finishedSelector;
- (void)queueGo;
- (void)downloadFile:(NSString *)fileURL toPath:(NSString *)path tag:(NSUInteger)tag delegate:(id)delegate;
-(void)clearCache;
@end
