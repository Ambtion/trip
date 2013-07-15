//
//  NotificationController.h
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "PlazeCell.h"
#import "SysNitificationCell.h"

@interface NotificationController : UIViewController<EGRefreshTableViewDelegate,UITableViewDataSource>
{
    EGRefreshTableView * _tableView;
}
@end
