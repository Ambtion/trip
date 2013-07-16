//
//  UserNotificationContentView.h
//  AhaTrip
//
//  Created by sohu on 13-7-16.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextView.h"

@class UserNotificationContentView;
@interface UserNotificationContentViewDataSource : NSObject
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * target;
@property(nonatomic,strong)NSString * targetName;
@property(nonatomic,strong)NSString * time;
- (CGFloat)heigth;
@end

@interface UserNotificationContentView : UIImageView
{
    UILabel * _nameLabel;
    UILabel * _content;
    UIImageView * _lineView;
    DetailTextView * _targetLabel;
    UILabel * _time;
    UserNotificationContentViewDataSource * _dataSource;
}
@property(nonatomic,strong)UserNotificationContentViewDataSource * dataSource;
@end
