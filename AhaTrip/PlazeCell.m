//
//  PlazeCell.m
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PlazeCell.h"
#import <objc/runtime.h>
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

static char Key_showKind;

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setCellShowEnable:YES];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = (self.frame.size.width - IMAGETAP) / 2.f;
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [_leftImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_leftImageView];
        _leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        _leftIcon.backgroundColor = [UIColor clearColor];
        [_leftImageView addSubview:_leftIcon];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture.numberOfTapsRequired = 1;
        [_leftImageView addGestureRecognizer:gesture];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_leftImageView.frame.size.width + IMAGETAP, 0, width, width)];
        [_rightImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_rightImageView];
        _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        _rightIcon.backgroundColor = [UIColor clearColor];
        [_rightImageView addSubview:_rightIcon];
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
    [_leftIcon setHidden:![self isCellShowEnable]];
    [_rightIcon setHidden:![self isCellShowEnable]];
    _leftImageView.image = [UIImage imageNamed:@"testImage.png"];
    [self setIconImage:_leftIcon Byinfo:_dataSource.leftInfo];
    [_rightImageView setHidden:![_dataSource rightInfo]];
    if (_dataSource.rightInfo){
        [_rightImageView setHidden:NO];
        _rightImageView.image = [UIImage imageNamed:@"testImage.png"];
        [self setIconImage:_rightIcon Byinfo:_dataSource.rightInfo];
    }else{
        [_rightImageView setHidden:YES];
        _rightImageView.image = nil;
    }
}
- (void)setIconImage:(UIImageView *)imageView Byinfo:(NSDictionary *)info
{
    [imageView setImage:[UIImage imageNamed:@"Entertainment.png"]];
}
- (void)setCellShowEnable:(BOOL)enabled
{
    objc_setAssociatedObject(self, &Key_showKind, [NSNumber numberWithBool:enabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isCellShowEnable
{
    return [objc_getAssociatedObject(self, &Key_showKind) boolValue];
}
@end
