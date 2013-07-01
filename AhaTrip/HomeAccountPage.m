//
//  HomeAccountPage.m
//  AhaTrip
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "HomeAccountPage.h"

@implementation HomeAccountPage
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
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15.f];
        _nameLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:_nameLabel];
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 5, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.font = [UIFont systemFontOfSize:9.f];
        _desLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:_desLabel];
        _segMent = [[HomeSegMent alloc] initWithFrame:CGRectMake(0, 180, 320, 45)];
        [self addSubview:_segMent];
        [self updataDatasource];
    }
    return self;
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_segMent addTarget:target action:action forControlEvents:controlEvents];
}

- (void)updataDatasource
{
    [_segMent setFinds:@"1" fav:@"9999+"];
    _nameLabel.text = @"Erfei_Chao";
    _desLabel.text = @"双脚踩灯泡，胸口碎大石";
    _portraitImageView.imageView.image = [UIImage imageNamed:@"testPor.png"];
}
@end
