//
//  NotificationCell.h
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"
#import "DetailTextView.h"
#import "UserNotificationContentView.h"

@class NotificationCell;
@interface NotificationCellDataSource : NSObject
{
    UserNotificationContentViewDataSource * _contentSouce;
}
@property(strong,nonatomic)NSString * portrait;
@property(strong,nonatomic)NSString * name;
@property(strong,nonatomic)NSString * content;
@property(strong,nonatomic)NSString * target;
@property(strong,nonatomic)NSString * targetName;
@property(strong,nonatomic)NSString * time;
@property(assign,nonatomic)NSInteger findId;
- (CGFloat)heigth;
- (UserNotificationContentViewDataSource *)contentSouce;
@end
@interface NotificationCell : UITableViewCell
{
    PortraitView * _portraitImageView;
    UserNotificationContentView * _userContentView;
    NotificationCellDataSource * _dataSource;
}
@property(nonatomic,strong)NotificationCellDataSource * dataSource;
@end
