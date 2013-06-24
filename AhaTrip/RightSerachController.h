//
//  RightSerachController.h
//  AhaTrip
//
//  Created by Qu on 13-6-23.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"

@interface CusSearchDisplayController : UISearchDisplayController
@end

@interface RightSerachController : UIViewController<EGRefreshTableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>
{
    UISearchBar * _searchBar;
    CusSearchDisplayController * _searchDisPlay;
    EGRefreshTableView * _tableView;
//    NSIndexPath * _selectedPath;
}
@end
