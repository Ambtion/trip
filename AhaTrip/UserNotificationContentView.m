//
//  UserNotificationContentView.m
//  AhaTrip
//
//  Created by sohu on 13-7-16.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "UserNotificationContentView.h"

#define CONTENTNAMEWIDTH    220.f
#define CONTENTMAXSIZE      CGSizeMake(CONTENTNAMEWIDTH, 1000000)
#define CONTENTFONT         [UIFont systemFontOfSize:15.f]

#define TARGETFONT          [UIFont boldSystemFontOfSize:15.f]
#define TARGETMAXSIZE       CONTENTMAXSIZE

@class UserNotificationContentView;
@implementation UserNotificationContentViewDataSource
@synthesize name = _name,content = _content,target = _target,time = _time;

- (CGFloat)heigth
{
    CGFloat heigth = 0.f;
    heigth += 10;
    heigth += 19.f;
    heigth += 5.f; //间隔
    heigth += [self.content sizeWithFont:CONTENTFONT constrainedToSize:CONTENTMAXSIZE].height;
    heigth += 15.f; //间隔
    heigth += [[NSString stringWithFormat:@"%@:%@",self.target,self.targetName] sizeWithFont:TARGETFONT constrainedToSize:TARGETMAXSIZE lineBreakMode:NSLineBreakByWordWrapping].height;
    heigth += 15.f;
    heigth += 12.f; //time 高度
    return heigth;
}
@end

@implementation UserNotificationContentView
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addNameLabel];
        [self addContentLabel];
        [self addLineBgView];
        [self addTargetLabel];
        [self addTimeLabel];
    }
    return self;
}
- (void)addNameLabel
{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10,CONTENTNAMEWIDTH, 19.f)];
    _nameLabel.numberOfLines = 1.f;
    _nameLabel.font = CONTENTFONT;
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
- (void)addLineBgView
{
    _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"content_line.png"]];
    _lineView.frame = CGRectMake(0, 0, 215, 1);
    _lineView.center = CGPointMake(self.frame.size.width/2.f, _lineView.center.y);
    [self addSubview:_lineView];
}
- (void)addTargetLabel
{
    _targetLabel = [[DetailTextView alloc] initWithFrame:CGRectZero];
    _targetLabel.backgroundColor = _nameLabel.backgroundColor;
    [self addSubview:_targetLabel];
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
    //line
    _lineView.frame = CGRectMake(_lineView.frame.origin.x, _content.frame.size.height + _content.frame.origin.y + 5, _lineView.frame.size.width, 1);
    //target
    CGSize targetSize = [_targetLabel.text sizeWithFont:TARGETFONT constrainedToSize:TARGETMAXSIZE lineBreakMode:NSLineBreakByWordWrapping];
    [_targetLabel setKeyWordTextArray:[NSArray arrayWithObjects:[_dataSource targetName],@":", nil] WithFont:[UIFont systemFontOfSize:15.f] AndColor:[UIColor colorWithRed:51.f/255 green:51.f/255 blue:51.f/255 alpha:1.f]];
    _targetLabel.frame = CGRectMake(_content.frame.origin.x, _content.frame.origin.y + _content.frame.size.height + 15, targetSize.width, targetSize.height);
    _time.frame = CGRectMake(rect.origin.x, _targetLabel.frame.size.height + _targetLabel.frame.origin.y + 15, rect.size.width, 12.f);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, _time.frame.origin.y + _time.frame.size.height + 5);
}
- (CGSize)getLabel:(UILabel *)label maxSize:(CGSize)maxSize
{
    return  [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
}

#pragma mark M_V_C
- (void)setDataSource:(UserNotificationContentViewDataSource *)dataSource
{
    
    if (_dataSource != dataSource){
        _dataSource = dataSource;
        _nameLabel.text = _dataSource.name;
        _content.text = _dataSource.content;
        [_targetLabel setText:[NSString stringWithFormat:@"%@:%@",_dataSource.target,_dataSource.targetName] WithFont:TARGETFONT AndColor:[UIColor blackColor]];
        _time.text = _dataSource.time;
        [self layoutsAllSubViews];
    }
}

@end
