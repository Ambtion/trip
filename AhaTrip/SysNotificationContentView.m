//
//  SysNotificationContentView.m
//  AhaTrip
//
//  Created by sohu on 13-7-15.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "SysNotificationContentView.h"

@implementation SysNotificationContentViewDataSource
@synthesize name = _name,content = _content,time = _time;
- (CGFloat)heigth
{
    CGFloat heigth = 0.f;
    heigth += 10;
    heigth += 19.f;
    heigth += 5.f; //间隔
    heigth += [self.content sizeWithFont:[UIFont systemFontOfSize:15.f] constrainedToSize:CGSizeMake(250.f - 30, 100000)].height;
    heigth += 15.f;
    heigth += 12.f; //time 高度
    return heigth;
}

@end
@implementation SysNotificationContentView
@synthesize dataSouce = _dataSouce;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 250.f;
    self = [super initWithFrame:frame];
    if (self) {
        [self addNameLabel];
        [self addContentLabel];
        [self addTimeLabel];
    }
    return self;
}
- (void)addNameLabel
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250.f - 30, 19.f)];
    _nameLabel.numberOfLines = 1.f;
    _nameLabel.font = [UIFont systemFontOfSize:15.f];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor =  [UIColor colorWithRed:2 /255.f green:94/255.f blue:153/255.f alpha:1.f];
    [self addSubview:_nameLabel];
}
- (void)addContentLabel
{
    _content = [[UILabel alloc] initWithFrame:CGRectZero];
    _content.font = _nameLabel.font;
    _content.numberOfLines = 0.f;
    _content.backgroundColor = _nameLabel.backgroundColor;
    _content.textColor = [UIColor blackColor];
    [self addSubview:_content];
}
- (void)addTimeLabel
{
    _time = [[UILabel alloc] initWithFrame:CGRectZero];
    _time.font = [UIFont systemFontOfSize:10.f];
    _time.backgroundColor = _nameLabel.backgroundColor;
    _time.textColor = [UIColor blackColor];
    [self addSubview:_time];
    
}
- (void)layoutsAllSubViews
{
    //label间隔 5
    CGRect rect = _nameLabel.frame;
    CGSize maxsize = CGSizeMake(_nameLabel.frame.size.width, 1000000);
    CGSize size = [self getLabel:_content maxSize:maxsize];
    _content.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 5, size.width,size.height);
    _time.frame = CGRectMake(rect.origin.x, _content.frame.size.height + _content.frame.origin.y + 15, rect.size.width, 12);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, _time.frame.origin.y + _time.frame.size.height + 5);
}
- (CGSize)getLabel:(UILabel *)label maxSize:(CGSize)maxSize
{
    return  [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
}

#pragma mark M_V_C
- (void)setDataSouce:(SysNotificationContentViewDataSource *)dataSouce
{
    
    if (_dataSouce != dataSouce){
        _dataSouce = dataSouce;
        _nameLabel.text = _dataSouce.name;
        _content.text = _dataSouce.content;
        _time.text = _dataSouce.time;
        _dataSouce = dataSouce;
        [self layoutsAllSubViews];
    }
}
@end
