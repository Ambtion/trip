//
//  SysNitificationCell.m
//  AhaTrip
//
//  Created by sohu on 13-7-15.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "SysNotificationCell.h"

@implementation SysNotificationCellDataSource
@synthesize portrait = _portrait,name = _name,content = _content,time = _time;

- (CGFloat)heigth
{
    CGFloat height = 0.f;
    height += 10.f; //上边界
    height += [[self contentSouce] heigth];
    height += 10.f; //下边界
    return height;
}
- (SysNotificationContentViewDataSource *)contentSouce
{
    if (!_contentSouce) {
        _contentSouce = [[SysNotificationContentViewDataSource alloc] init];
        _contentSouce.name = self.name;
        _contentSouce.content = self.content;
        _contentSouce.time = self.time;
    }
    return _contentSouce;
}
@end
@implementation SysNotificationCell

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
    _portraitView = [[PortraitView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.contentView addSubview:_portraitView];
}
- (void)addContentView
{
    _sysContentView = [[SysNotificationContentView alloc] initWithFrame:CGRectMake(60,10,250,0)];
    _sysContentView.image = [[UIImage imageNamed:@"contentBgView.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 120, 85, 120)];
    [self.contentView addSubview:_sysContentView];
}

#pragma mark  - 
- (void)setDataSource:(SysNotificationCellDataSource *)dataSource
{
    if (_dataSource != dataSource){
        _dataSource = dataSource;
        [self updateSubViews];
    }
}
- (void)updateSubViews
{
    _portraitView.imageView.image = _dataSource.portrait;
    _sysContentView.dataSouce = [_dataSource  contentSouce];
    self.frame = CGRectMake(0, 0, 320, _sysContentView.frame.size.height + _sysContentView.frame.origin.y);
}
@end
