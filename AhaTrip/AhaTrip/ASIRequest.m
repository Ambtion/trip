//
//  ASIRequest.m
//  嘉德
//
//  Created by tagux imac04 on 13-1-22.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "ASIRequest.h"
#import "ASIDownloadCache.h"
#import "NetworkState.h"

@interface ASIRequest ()
@property (retain, nonatomic) ASINetworkQueue *queue;
@property (retain, nonatomic) NSMutableArray   *requests;
@property (retain, nonatomic) ASIDownloadCache *cache;

@end

@implementation ASIRequest


+ (ASIRequest *)shareInstance
{
    static ASIRequest *asiRequest = nil;

    @synchronized(self)
    {
        if (!asiRequest)
        {
            asiRequest = [[ASIRequest alloc] init];
        }
    }
    
    return asiRequest;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.requests = [NSMutableArray array];
        
        self.cache = [ASIDownloadCache sharedCache];
        [self.cache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    }
    
    return self;
}

- (void)addQueueToTarget:(id)target finishedSelector:(SEL)finishedSelector
{
    self.queue = [ASINetworkQueue queue];
    self.queue.delegate = target;
    self.queue.queueDidFinishSelector = finishedSelector;
}

- (void)queueGo
{
    [self.queue go];
}

+ (void)get:(NSString *)url header:(NSDictionary *)header delegate:(id)delegate tag:(NSUInteger)tag
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTag:tag];
    [request setDelegate:delegate];
    
    NSEnumerator *headerEnum = [header keyEnumerator];
    NSString *keyName = nil;
    while ((keyName = headerEnum.nextObject) != nil)
    {
        [request addRequestHeader:keyName value:[header objectForKey:keyName]];
    }
    
    [request startAsynchronous];
}

+ (void)post:(NSString *)url header:(NSDictionary *)header body:(NSDictionary *)body delegate:(id)delegate tag:(NSUInteger)tag
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTag:tag];
    [request setDelegate:delegate];
//    [request setTimeOutSeconds:25];

    NSEnumerator *headerEnum = [header keyEnumerator];
    NSString *keyName = nil;
    while ((keyName = headerEnum.nextObject) != nil)
    {
        [request addRequestHeader:keyName value:[header objectForKey:keyName]];
    }
    
    keyName = nil;
    NSEnumerator *bodyEnum = [body keyEnumerator];
    while ((keyName = bodyEnum.nextObject) != nil)
    {
        [request addPostValue:[body objectForKey:keyName] forKey:keyName];
    }
    
    [request startAsynchronous];
}

- (void)get:(NSString *)url header:(NSDictionary *)header delegate:(id)delegate tag:(NSUInteger)tag useCache:(BOOL)useCache
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTag:tag];

    BOOL  canDownloadData = [[NSUserDefaults standardUserDefaults] boolForKey:kCanDownloadData];
    if (!canDownloadData && ![NetworkState isEnableWIFI]&&[NetworkState isEnableNetwork])
    {
        [delegate requestFailed:request];
        
              return;
    }
    
    [request setDelegate:delegate];
    NSEnumerator *headerEnum = [header keyEnumerator];
    NSString *keyName = nil;
    while ((keyName = headerEnum.nextObject) != nil)
    {
        [request addRequestHeader:keyName value:[header objectForKey:keyName]];
    }
    
    if (useCache)
       
    {
        
       
        if (![NetworkState isEnableNetwork]) {
            
            [self.cache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
            
            [request setDownloadCache:self.cache];
            
        }else{
        
            [request setCacheStoragePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            
           [request setDownloadCache:self.cache];
            NSLog(@"%@",self.cache);
           
        
        
        }

             
    }
    [self.requests addObject:request];
    
    
    [request startAsynchronous];

    
  
    

}

- (void)post:(NSString *)url header:(NSDictionary *)header body:(NSDictionary *)body delegate:(id)delegate tag:(NSUInteger)tag
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTag:tag];
    
    BOOL  canDownloadData = [[NSUserDefaults standardUserDefaults] boolForKey:kCanDownloadData];
    if (!canDownloadData && ![NetworkState isEnableWIFI])
    {
        if ([delegate respondsToSelector:@selector(requestFailed:)])
        {
            [delegate requestFailed:request];
        }
        return;
    }
    
    [request setDelegate:delegate];
    //    [request setTimeOutSeconds:25];
    
    NSEnumerator *headerEnum = [header keyEnumerator];
    NSString *keyName = nil;
    while ((keyName = headerEnum.nextObject) != nil)
    {
        [request addRequestHeader:keyName value:[header objectForKey:keyName]];
    }
    
    keyName = nil;
    NSEnumerator *bodyEnum = [body keyEnumerator];
    while ((keyName = bodyEnum.nextObject) != nil)
    {
        [request addPostValue:[body objectForKey:keyName] forKey:keyName];
    }
    
    [self.requests addObject:request];
    
    [request startAsynchronous];
}

- (void)clearAllDelegate
{
    for (ASIHTTPRequest *request in self.requests)
    {
        [request clearDelegatesAndCancel];
    }
}


- (void)clearAllRequestDelegateAndCancel
{
    for (ASIHTTPRequest *request in self.requests)
    {
        [request clearDelegatesAndCancel];
    }
}

- (void)clearRequestDelegateAndCancel:(ASIHTTPRequest *)request
{
    if ([self.requests containsObject:request])
    {
        [request clearDelegatesAndCancel];
    }
}
-(void)clearCache{
    [self.cache clearCachedResponsesForStoragePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];

}

- (void)downloadFile:(NSString *)url toPath:(NSString *)path tag:(NSUInteger)tag delegate:(id)delegate
{    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDownloadDestinationPath:path];
    [request setDelegate:delegate];
    [request setTag:tag];
    [request setNumberOfTimesToRetryOnTimeout:2];

    if (self.queue)
        [self.queue addOperation:request];
    else
        [request startAsynchronous];
}


@end
