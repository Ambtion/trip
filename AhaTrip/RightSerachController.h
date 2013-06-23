//
//  RightSerachController.h
//  AhaTrip
//
//  Created by Qu on 13-6-23.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "CusSearchDisplayController.h"
@interface RightSerachController : UIViewController<EGRefreshTableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
{
    EGRefreshTableView * _tableView;
    UISearchBar * _searchBar;
    CusSearchDisplayController * _searchDisPlay;
}
@end
