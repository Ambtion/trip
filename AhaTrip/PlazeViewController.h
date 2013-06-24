//
//  PlarzeViewController.h
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "AwesomeMenu.h"

@interface PlazeViewController : UIViewController<AwesomeMenuDelegate,EGRefreshTableViewDelegate,UITableViewDataSource>
{
    EGRefreshTableView * _tableView;
}
@end
