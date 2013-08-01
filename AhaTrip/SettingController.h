//
//  SettingController.h
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AcountSettingCell.h"
#import "BindCell.h"
#import "TitleCell.h"

@interface SettingController : UIViewController<UITableViewDataSource,UITableViewDelegate,BindCellDelegate,AcountSettingCellDelegate,UIAlertViewDelegate,IIViewDeckControllerDelegate>
{
    UITableView * _tableView;
    AcountSettingCellDataSource * acountSource;
}
@end
