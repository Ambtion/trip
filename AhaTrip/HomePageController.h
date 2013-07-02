//
//  HomePageController.h
//  AhaTrip
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGRefreshTableView.h"
#import "PhotoDetailController.h"
#import "PlazeCell.h"
#import "HomeAccountPage.h"

@interface HomePageController : UIViewController<EGRefreshTableViewDelegate,UITableViewDataSource,PlazeCellDelegate,IIViewDeckControllerDelegate>
{
    
    EGRefreshTableView * _tableView;
    HomeAccountPage * _homeAccountPage;
    UIButton * _backButton;
    BOOL _isRootController;
}
- (id)initAsRootViewController:(BOOL)isRoot;
@end