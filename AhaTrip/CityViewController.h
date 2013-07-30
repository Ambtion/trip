//
//  CityViewController.h
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"

@interface CityViewController : UIViewController<EGRefreshTableViewDelegate,UITableViewDataSource>
{
    EGRefreshTableView * _tableView;
    int _identify;
}
- (id)initWithIdentify:(int)identify;
@end
