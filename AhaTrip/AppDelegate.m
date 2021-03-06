//
//  AppDelegate.m
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "AppDelegate.h"
#import "Umeng/UMAppKey.h"
#import "ProjectGuideView.h"
#import "IIViewDeckController.h"
#import "PlazeViewController.h"
#import "LeftMenuController.h"
#import "RightSerachController.h"
#import "RequestManager.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize lib = _lib;

- (void)configProject
{
    //this register umeng
    [MobClick startWithAppkey:UM_APP_KEY];
    [ProjectGuideView showViewWithDelegate:nil];
    //this register notification
    [[UIApplication sharedApplication]  registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |
                                                                             UIRemoteNotificationTypeSound)];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    //主视图
    PlazeViewController * lp = [[PlazeViewController alloc] init];
    //左菜单
    LeftMenuController * leftVC = [[LeftMenuController alloc] init];
    leftVC.plazeController = lp;
    
    //右边菜单
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController: [[RightSerachController alloc] init]];
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [nav.navigationBar setHidden:YES];
    
    IIViewDeckController * deckViewController = [[IIViewDeckController alloc] initWithCenterViewController:lp leftViewController:leftVC rightViewController:nav];
    UINavigationController * nav_center = [[UINavigationController alloc] initWithRootViewController:deckViewController];
    [nav_center.navigationBar setHidden:YES];
    self.window.rootViewController = nav_center;
    [self.window makeKeyAndVisible];
    [self configProject];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [NSString stringWithFormat:@"%@",deviceToken];
    DLog(@"%@",token);
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
//    DLog(@"token::%@",token);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", error];
    DLog(@"%@",str);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary  *)userInfo
{
    NSLog(@"%@",[userInfo allKeys]);
    NSLog(@"%@",userInfo);
    UIAlertView * alterview = [[UIAlertView alloc] initWithTitle:@"通知" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"详细", nil];
    [alterview show];
    application.applicationIconBadgeNumber += [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
    [self postNotification];
}
- (void)postNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceiveRemoteNotification" object:nil];
}
- (ALAssetsLibrary *)appDefaultAssetLib
{
    if (!self.lib) {
        self.lib = [[ALAssetsLibrary alloc] init];
    }
    return self.lib;
}
@end
