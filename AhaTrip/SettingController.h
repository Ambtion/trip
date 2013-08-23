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
#import "DLCImagePickerController.h"
#import "OAuthShareRef.h"


@interface SettingController : UIViewController<UITableViewDataSource,UITableViewDelegate,BindCellDelegate,AcountSettingCellDelegate,UIAlertViewDelegate,IIViewDeckControllerDelegate,UIActionSheetDelegate,DLCImagePickerDelegate,TencentSessionDelegate,SinaWeiboDelegate>
{
    UITableView * _tableView;
    AcountSettingCellDataSource * acountSource;
    AcountSettingCell * _acountCell;
    BindCell * _qqCell;
    BindCell * _sinaCell;
    BOOL shouldUpload;
}
- (void)getUserInfo;
@end
