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
#import "PlazeCell.h"
#import "AHMenuNavBarView.h"
#import "RightSerachController.h"

@interface PlazeViewController : UIViewController<AwesomeMenuDelegate,EGRefreshTableViewDelegate,UITableViewDataSource,PlazeCellDelegate,AHMenuNavBarViewDelegate,IIViewDeckControllerDelegate,LoginViewControllerDelegate>
{
    EGRefreshTableView * _tableView;
    CGFloat _startFolat;
    RightSerachController * _rightSearch;
    AHMenuNavBarView * _menuView;

}
@property(nonatomic,strong)NSMutableArray * assetsArray;
@property(nonatomic,strong)NSMutableArray * dataSouceArray;
- (void)refresFromeNetWork;
- (void)getMoreFromeNetWork;
- (void)convertAssetsToDataSouce;
@end
