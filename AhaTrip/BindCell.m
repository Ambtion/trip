//
//  BindCell.m
//  AhaTrip
//
//  Created by sohu on 13-7-4.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "BindCell.h"

@implementation BindCell
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView * view = [[UIImageView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
        UIImageView * lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settting_line.png"]];
        lineView.frame = CGRectMake(0, self.bounds.size.height - 1 + self.bounds.origin.y, self.bounds.size.width, 1);
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:lineView];
        [self addAllSubViews];
    }
    return self;
}

- (void)addAllSubViews
{
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(19, (self.frame.size.height - 31)/2.f, 31, 31)];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 0, 120, self.frame.size.height)];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:13.f];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.nameLabel];
    self.bindSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 0, 0, 0)];
    self.bindSwitch.center = CGPointMake(self.bindSwitch.center.x, self.frame.size.height /2.f);
    [self.bindSwitch addTarget:self action:@selector(switchDidValueChanged:) forControlEvents:UIControlEventValueChanged];
    DLog(@"%@",NSStringFromCGRect(self.bindSwitch.frame));
    [self.contentView addSubview:self.bindSwitch];
}
- (void)switchDidValueChanged:(UISwitch *)bindSwicth
{
    if ([_delegate respondsToSelector:@selector(BindCell:SwithChanged:)])
        [_delegate BindCell:self SwithChanged:bindSwicth];
}
@end
