//
//  TitleCell.m
//  AhaTrip
//
//  Created by sohu on 13-7-4.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell
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
        
        self.textLabel.font = [UIFont systemFontOfSize:18.f];
        self.textLabel.shadowColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end
