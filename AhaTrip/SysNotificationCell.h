//
//  SysNitificationCell.h
//  AhaTrip
//
//  Created by sohu on 13-7-15.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"
#import "SysNotificationContentView.h"
@class SysNotificationCell;
@interface SysNotificationCellDataSource : NSObject
{
    SysNotificationContentViewDataSource * _contentSouce;
}
@property(strong,nonatomic)UIImage * portrait;
@property(strong,nonatomic)NSString * name;
@property(strong,nonatomic)NSString * content;
@property(strong,nonatomic)NSString * time;
- (CGFloat)heigth;
- (SysNotificationContentViewDataSource *)contentSouce;
@end
@interface SysNotificationCell : UITableViewCell
{
    PortraitView * _portraitView;
    SysNotificationCellDataSource * _dataSource;
    SysNotificationContentView* _sysContentView;
}
@property(strong,nonatomic)SysNotificationCellDataSource * dataSource;
@end
