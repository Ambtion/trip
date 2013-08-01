//
//  AppDelegateOauthor.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthShareRef.h"

@interface AppDelegateOauthor : UIResponder<UIApplicationDelegate>
{
    SinaWeibo * sinaweibo;
    TencentOAuth * tencentOAuth;
    __weak id<QQApiInterfaceDelegate> _qqtempDelegate;
}
@property(nonatomic,strong)TencentOAuth * tencentOAuth;
@property(nonatomic,strong)SinaWeibo * sinaweibo;

- (void)sinaLoginWithDelegate:(id<SinaWeiboDelegate>)delegate;
- (void)qqLoginWithDelegate:(id<TencentSessionDelegate>)delegate;
- (void)qqregisterWithDelegate:(id<QQApiInterfaceDelegate>)delegate;
@end
