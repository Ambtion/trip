//
//  PlazeCell.m
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PlazeCell.h"
#define IMAGETAP 4

@implementation PlazeCellDataSource
@synthesize rightInfo,leftInfo;
+ (CGFloat)cellHight
{
    CGFloat width = (320 - IMAGETAP) / 2.f;
    return width + IMAGETAP;
}
@end
@implementation PlazeCell
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = (self.frame.size.width - IMAGETAP) / 2.f;
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [_leftImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_leftImageView];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture.numberOfTapsRequired = 1;
        [_leftImageView addGestureRecognizer:gesture];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_leftImageView.frame.size.width + IMAGETAP, 0, width, width)];
        [_rightImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_rightImageView];
        UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture2.numberOfTapsRequired = 1;
        [_rightImageView addGestureRecognizer:gesture2];
    }
    return self;
}

- (void)handleGusture:(UIGestureRecognizer *)gesture
{
    UIImageView *  view = (UIImageView *)[gesture view];
    NSDictionary * infoDic = nil;
    if ([view isEqual:_leftImageView]) {
        infoDic = _dataSource.leftInfo;
    }else{
        infoDic = _dataSource.rightInfo;
    }
    if ([_delegate respondsToSelector:@selector(PlazeCell:clickCoverGroup:)])
        [_delegate PlazeCell:self clickCoverGroup:infoDic];
}

#pragma mark -DataSource
- (PlazeCellDataSource *)dataSource
{
    return _dataSource;
}
- (void)setDataSource:(PlazeCellDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self updataImageViews];
    }
}
- (void)updataImageViews
{
    _leftImageView.image = [UIImage imageNamed:@"testImage.png"];
    [_rightImageView setHidden:![_dataSource rightInfo]];
    if (_dataSource.rightInfo){
        [_rightImageView setHidden:NO];
        _rightImageView.image = [UIImage imageNamed:@"testImage.png"];
    }else{
        [_rightImageView setHidden:YES];
        _rightImageView.image = nil;
    }
}

@end
