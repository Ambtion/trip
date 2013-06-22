//
//  LeftMenuCell.m
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "LeftMenuCell.h"

@implementation LeftMenuCell
@synthesize iconImage = _iconImage;
@synthesize titleLabel = _titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self addIconView];
        [self addTitleLabel];
    }
    return self;
}
- (void)addIconView
{
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 30)/2.f, 30, 30)];
    [self.contentView addSubview:self.iconImage];
}
- (void)addTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,0,200,self.frame.size.height)];
    self.titleLabel.backgroundColor = [UIColor grayColor];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.titleLabel];
}
@end
