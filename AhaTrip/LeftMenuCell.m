//
//  LeftMenuCell.m
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "LeftMenuCell.h"
#define OFFSETX 10

@implementation LeftMenuCell
@synthesize iconImage = _iconImage;
@synthesize titleLabel = _titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
                
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenuHigthed.png"]];
        image.backgroundColor = [UIColor clearColor];
//        image.image = nil;
        image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        image.frame = self.bounds;
        self.selectedBackgroundView = image;
        UIImageView * line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cutline.png"]];
        line.frame = CGRectMake(0, self.frame.size.height - 2, 320, 2);
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:line];
        [self addIconView];
        [self addTitleLabel];
        [self addCountLabel];
        [self addArrow];
    }
    return self;
}
- (void)addIconView
{
    self.iconImage = [[PortraitView alloc] initWithFrame:CGRectMake(10 + OFFSETX, (self.frame.size.height - 28)/2.f, 28, 28)];
    [self.contentView addSubview:self.iconImage];
}
- (void)addTitleLabel
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 + OFFSETX,0,150,self.frame.size.height)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor colorWithRed:204.f/255 green:204.f/255 blue:204.f/255 alpha:1];
    self.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [self.contentView addSubview:self.titleLabel];
}
- (void)addCountLabel
{
    self.countLabel = [[CountLabel alloc] initWithFrame:CGRectMake(108 + OFFSETX, (self.frame.size.height - 20)/2.f, 20, 20)];
//    [self.countLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.contentView addSubview:self.countLabel];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.text = @" 20 ";
}
- (void)addArrow
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow.png"]];
    imageView.frame = CGRectMake(240, (self.frame.size.height - 9)/2.f , 8, 9);
    [self.contentView addSubview:imageView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        DLog(@"%@",self.subviews);
    }
}
@end
