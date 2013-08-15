//
//  LeftViewController.h
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlazeViewController.h"
#import "HomePageController.h"
#import "NotificationController.h"
#import "SettingController.h"
@interface LeftMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSIndexPath * _selectPath;
    
    PlazeViewController * _plazeController;
    HomePageController * _homeController;
    NotificationController * _ntfController;
    SettingController * _setController;
    NSDictionary * _userInfo;
}
@property(nonatomic,strong)PlazeViewController * plazeController;
@property(nonatomic,strong)HomePageController * homeController;
@property(nonatomic,strong)NotificationController * ntfController;
@property(nonatomic,strong)SettingController * setController;
@end
