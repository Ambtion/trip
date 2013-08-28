//
//  PlazeCell.m
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PlazeCell.h"
#import "UIImageView+WebCache.h"
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
static char Key_showCity;

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setCellShowIconEnable:YES];
        [self setCellShowCityEnable:YES];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = (self.frame.size.width - IMAGETAP) / 2.f;
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [_leftImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_leftImageView];
        _leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        _leftIcon.backgroundColor = [UIColor clearColor];
        _leftIcon.layer.shadowOffset = CGSizeMake(0, 1);
        _leftIcon.layer.shadowColor = [[UIColor blackColor] CGColor];
        _leftIcon.layer.shadowOpacity = 0.4;
        [_leftImageView addSubview:_leftIcon];
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, 20)];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        _leftLabel.shadowOffset = CGSizeMake(0, 1);
        [_leftImageView addSubview:_leftLabel];
        
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture.numberOfTapsRequired = 1;
        [_leftImageView addGestureRecognizer:gesture];
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
        [_leftImageView addGestureRecognizer:longGes];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_leftImageView.frame.size.width + IMAGETAP, 0, width, width)];
        [_rightImageView setUserInteractionEnabled:YES];
        [self.contentView addSubview:_rightImageView];
        _rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        _rightIcon.backgroundColor = [UIColor clearColor];
        _rightIcon.layer.shadowOffset = CGSizeMake(0, 1);
        _rightIcon.layer.shadowColor = [[UIColor blackColor] CGColor];
        _rightIcon.layer.shadowOpacity = 0.4;
        [_rightImageView addSubview:_rightIcon];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, 20)];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        _rightLabel.shadowOffset = CGSizeMake(0, 1);

        [_rightImageView addSubview:_rightLabel];
        
        UITapGestureRecognizer * gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGusture:)];
        gesture2.numberOfTapsRequired = 1;
        [_rightImageView addGestureRecognizer:gesture2];
        
        UILongPressGestureRecognizer * longGes2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
        [_leftImageView addGestureRecognizer:longGes2];
        
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
- (void)longGesture:(UIGestureRecognizer *)gesture
{
    if (gesture.state != UIGestureRecognizerStateBegan) {
        UIImageView *  view = (UIImageView *)[gesture view];
        NSDictionary * infoDic = nil;
        if ([view isEqual:_leftImageView]) {
            infoDic = _dataSource.leftInfo;
        }else{
            infoDic = _dataSource.rightInfo;
        }
        if ([_delegate respondsToSelector:@selector(PlazeCell:longPressGroup:)])
            [_delegate PlazeCell:self longPressGroup:infoDic];
    }
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
    [_leftIcon setHidden:![self isCellShowIconEnable]];
    [_rightIcon setHidden:![self isCellShowIconEnable]];
    
    [_leftLabel setHidden:![self isCellShowCityEnable]];
    [_rightLabel setHidden:![self isCellShowCityEnable]];
    
//    [_leftImageView setImageWithURL:[NSURL URLWithString:[_dataSource.leftInfo objectForKey:@"photo_thumb"]]placeholderImage:[UIImage imageNamed:@"loding_bg.png"]];
       [_leftImageView setImageWithURL:[NSURL URLWithString:[_dataSource.leftInfo objectForKey:@"photo_thumb"]]];
    _leftLabel.text =[self getCityNameFromDic:_dataSource.leftInfo];
    [self setIconImage:_leftIcon Byinfo:_dataSource.leftInfo];
    [_rightImageView setHidden:![_dataSource rightInfo]];
    if (_dataSource.rightInfo){
        [_rightImageView setHidden:NO];
        [_rightImageView setImageWithURL:[NSURL URLWithString:[_dataSource.rightInfo objectForKey:@"photo_thumb"]]];
        _rightLabel.text = [self getCityNameFromDic:_dataSource.rightInfo];
        [self setIconImage:_rightIcon Byinfo:_dataSource.rightInfo];
    }else{
        [_rightImageView setHidden:YES];
        _rightImageView.image = nil;
    }
}

- (NSString *)getCityNameFromDic:(NSDictionary*)dic
{
    return [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"country"],[dic objectForKey:@"city"]];
}
- (void)setIconImage:(UIImageView *)imageView Byinfo:(NSDictionary *)info
{
    [imageView setImage:[UIImage imageNamed:[self getCateryImage:[[info objectForKey:@"category_id"] intValue] - 1]]];
}

#pragma mark 
- (void)setCellShowIconEnable:(BOOL)enabled
{
    objc_setAssociatedObject(self, &Key_showKind, [NSNumber numberWithBool:enabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isCellShowIconEnable
{
    return [objc_getAssociatedObject(self, &Key_showKind) boolValue];
}
- (void)setCellShowCityEnable:(BOOL)enabled
{
    objc_setAssociatedObject(self, &Key_showCity, [NSNumber numberWithBool:enabled], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isCellShowCityEnable
{
    return [objc_getAssociatedObject(self, &Key_showCity) boolValue];
}

@end
