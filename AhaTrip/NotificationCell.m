//
//  NotificationCell.m
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "NotificationCell.h"
#import "UIImageView+WebCache.h"

@implementation NotificationCellDataSource
@synthesize portrait = _portrait, name = _name,content = _content,target = _target,targetName = _targetName, time= _time,findId = _findId;
- (CGFloat)heigth
{
    CGFloat height = 0.f;
    height += 10.f; //上边界
    height += [[self contentSouce] heigth];
    height += 10.f; //下边界
    return height;
}
- (UserNotificationContentViewDataSource *)contentSouce
{
    if (!_contentSouce) {
        _contentSouce = [[UserNotificationContentViewDataSource alloc] init];
        _contentSouce.name = self.name;
        _contentSouce.content = self.content;
        _contentSouce.target = self.target;
        _contentSouce.targetName = self.targetName;
        _contentSouce.time = self.time;
    }
    return _contentSouce;
}
@end
@implementation NotificationCell
@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addPortraitView];
        [self addContentView];
    }
    return self;
}

- (void)addPortraitView
{
    _portraitImageView = [[PortraitView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.contentView addSubview:_portraitImageView];
}
- (void)addContentView
{
    _userContentView = [[UserNotificationContentView alloc] initWithFrame:CGRectMake(60,10,250,0)];
    _userContentView.image = [[UIImage imageNamed:@"contentBgView.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 120, 85, 120)];
    [self.contentView addSubview:_userContentView];
}

#pragma mark  -
- (void)setDataSource:(NotificationCellDataSource *)dataSource
{
    if (_dataSource != dataSource){
        _dataSource = dataSource;
        [self updateSubViews];
    }
}
- (void)updateSubViews
{
    [_portraitImageView.imageView setImageWithURL:[NSURL URLWithString:_dataSource.portrait]];
    _userContentView.dataSource = [_dataSource  contentSouce];
    self.frame = CGRectMake(0, 0, 320, _userContentView.frame.size.height + _userContentView.frame.origin.y);
}
@end
