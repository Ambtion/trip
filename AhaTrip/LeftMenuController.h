//
//  LeftViewController.h
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableView;
    NSIndexPath * _selectPath;
}
@end
