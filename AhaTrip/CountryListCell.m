//
//  CityListCell.m
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "CountryListCell.h"

@implementation CountryListCellDataSource
@synthesize cName,eName,identify;
@end

@implementation CountryListCell
@synthesize arrow;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, self.frame.size.width, 44);
        _offset = 20.f;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _bgview = [[UIView alloc] initWithFrame:self.bounds];
        _bgview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _bgview.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
        [self.contentView addSubview:_bgview];
        UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cutline.png"]];
        line.frame = CGRectMake(0, self.frame.size.height - 2, 320, 2);
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_bgview addSubview:line];
        [self addCNameLabel];
        [self addENameLabel];
        [self addArrow];
    }
    return self;
}
- (UIView *)getBgView
{
    [arrow setHidden:YES];
    return _bgview;
}
- (void)addCNameLabel
{
    _cNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _cNameLabel.font = [UIFont boldSystemFontOfSize:20.f];
    _cNameLabel.backgroundColor = [UIColor clearColor];
    CGFloat colorF = 204/255.f;
    _cNameLabel.textColor = [UIColor colorWithRed:colorF green:colorF blue:colorF alpha:1];
    [_bgview addSubview:_cNameLabel];
}

- (void)addENameLabel
{
    _eNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    CGFloat colorF = 204/255.f;
    _eNameLabel.backgroundColor = [UIColor clearColor];
    _eNameLabel.textColor = [UIColor colorWithRed:colorF green:colorF blue:colorF alpha:1];
    _eNameLabel.font = [UIFont systemFontOfSize:14];
    [_bgview addSubview:_eNameLabel];
}

- (void)addArrow
{
    arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]];
    arrow.frame = CGRectMake(240, (self.frame.size.height - 9)/2.f , 8, 9);
    [_bgview addSubview:arrow];
}

#pragma mark setData
- (void)setoffset:(CGFloat)offset
{
    _offset = offset;
    [self updataViewdata];
}
- (CountryListCellDataSource *)dataSource
{
    return _dataSource;
}
- (void)setDataSource:(CountryListCellDataSource *)dataSource
{
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        [self updataViewdata];
    }
}
- (void)updataViewdata
{
    [self layoutLabel];
}
- (void)layoutLabel
{
    _cNameLabel.text = _dataSource.cName;
    [_cNameLabel sizeToFit];
    _eNameLabel.text = _dataSource.eName;
    [_eNameLabel sizeToFit];
    
    [_eNameLabel setHidden:![_dataSource eName]];
    CGRect cRect = _cNameLabel.frame;
    cRect.origin.x =  _offset;
    cRect.origin.y = (self.frame.size.height - cRect.size.height) /2.f;
    _cNameLabel.frame = cRect;
    
    CGRect rect = _eNameLabel.frame;
    rect.origin.x = cRect.origin.x + cRect.size.width + 5;
    rect.origin.y = cRect.origin.y + cRect.size.height - rect.size.height;
    _eNameLabel.frame = rect;

}
@end
