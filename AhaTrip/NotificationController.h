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
#import "SysNotificationCell.h"
#import "NotificationCell.h"
#import "CommentController.h"

@interface NotificationController : UIViewController<EGRefreshTableViewDelegate,IIViewDeckControllerDelegate,UITableViewDataSource>
{
    EGRefreshTableView * _tableView;
}
@end
