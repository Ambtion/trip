//
//  HomeAccountPage.m
//  AhaTrip
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "HomeAccountPage.h"
#import "UIImageView+WebCache.h"

@implementation HomeAccountPageDataSource
@synthesize name,descrip,portraitUrl,finds,favorite;
@end

@implementation HomeAccountPage
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = 180 + 53;
    self = [super initWithFrame:frame];
    if (self) {
        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        _bgImageView.image = [UIImage imageNamed:@"profileBg.png"];
        [self addSubview:_bgImageView];
        _portraitImageView = [[PortraitView alloc] initWithFrame:CGRectMake(320 - 120 - 15, 45, 120, 120)];
        [self addSubview:_portraitImageView];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 70, 130, 26)];
        _nameLabel.font = [UIFont systemFontOfSize:22.f];
        [self setLabelCommonPorperty:_nameLabel];
        [self addSubview:_nameLabel];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 5, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        _desLabel.font = [UIFont systemFontOfSize:12.f];
        [self setLabelCommonPorperty:_desLabel];
        [self addSubview:_desLabel];
        
        _segMent = [[HomeSegMent alloc] initWithFrame:CGRectMake(0, 180, 320, 45)];
        [self addSubview:_segMent];
        [self updataDatasource];
    }
    return self;
}
- (void)setLabelCommonPorperty:(UILabel *)label
{
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentRight;
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
     [_segMent addTarget:target action:action forControlEvents:controlEvents];
}
- (void)setDataSource:(HomeAccountPageDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self updataDatasource];
    }
}
- (void)updataDatasource
{
    DLog(@"%@ %@",_dataSource.name,_dataSource.descrip);
    _nameLabel.text =_dataSource.name;
    _desLabel.text = _dataSource.descrip;
    [_portraitImageView.imageView setImageWithURL:[NSURL URLWithString:_dataSource.portraitUrl] placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    [_segMent setFinds:[self getCount:_dataSource.finds] fav:[self getCount:_dataSource.favorite]];
}
- (NSString *)getCount:(NSInteger)count
{
    if (count > 99)
        return [NSString stringWithFormat:@"%d+",count];
    else
        return [NSString stringWithFormat:@"%d",count];
}
@end
