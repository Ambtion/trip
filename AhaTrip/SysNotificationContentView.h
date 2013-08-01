//
//  SysNotificationContentView.h
//  AhaTrip
//
//  Created by sohu on 13-7-15.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SysNotificationContentView;
@interface SysNotificationContentViewDataSource : NSObject
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * time;
- (CGFloat)heigth;
@end

@interface SysNotificationContentView : UIImageView
{
    UILabel * _nameLabel;
    UILabel * _content;
    UILabel * _time;
    SysNotificationContentViewDataSource * _dataSouce;
}
@property(nonatomic,strong)SysNotificationContentViewDataSource * dataSouce;
@end
