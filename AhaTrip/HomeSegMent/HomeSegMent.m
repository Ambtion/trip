//
//  HomeSegMent.m
//  SegMentView
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 sohu. All rights reserved.
//


#import "HomeSegMent.h"
#define HIGHTEDCOLOR    [UIColor colorWithRed:50/255.f green:200/255.f blue:160/255.f alpha:1]
#define NOMALCOLOR      [UIColor blackColor]

@interface HomeSegMentItems : UIImageView
@property(nonatomic,strong)UILabel * label;
@end

@implementation HomeSegMentItems

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(44, 12, 56, 15)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.f];
        self.label.textColor = NOMALCOLOR;
        [self addSubview:self.label];
    }
    return self;
}

@end

@implementation HomeSegMent

@synthesize seletedIndexPath = _seletedIndexPath;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 320.f;
    frame.size.height = 45.f;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeSeg_arrow.png"]];
        [self addSubview:_bgView];
        _bgView.frame = CGRectMake(-100,0,40, 20);
        _leftItem = [[HomeSegMentItems alloc] initWithFrame:CGRectMake(15, 0, 100, 45)];
        _leftItem.tag = 100;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_leftItem addGestureRecognizer:tap];
        [self addSubview:_leftItem];
        _rightItem = [[HomeSegMentItems alloc] initWithFrame:CGRectMake(115, 0, 100, 45)];
        _rightItem.tag = 101;
        _rightItem.label.text = @"9999+";
        _leftItem.label.text = @"1";
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_rightItem addGestureRecognizer:tap1];
        [self addSubview:_rightItem];
        _seletedIndexPath = -1;
        self.seletedIndexPath = 0;
    }
    return self;
}
- (void)tapGesture:(UIGestureRecognizer *)gesture
{
    switch (gesture.view.tag) {
        case 100:
            [self setSeletedIndexPath:0];
            break;
        case 101:
            [self setSeletedIndexPath:1];
            break;
        default:
            break;
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
- (void)setItemsSeletedState
{
    switch (self.seletedIndexPath) {
        case 0:
            _leftItem.image = [UIImage imageNamed:@"find-1.png"];
            _leftItem.label.textColor = HIGHTEDCOLOR;
            _rightItem.image = [UIImage imageNamed:@"favorite-2.png"];
            _rightItem.label.textColor = NOMALCOLOR;
            break;
        case 1:
            _leftItem.image = [UIImage imageNamed:@"find-2.png"];
            _rightItem.image = [UIImage imageNamed:@"favorite-1.png"];
            _leftItem.label.textColor = NOMALCOLOR;
            _rightItem.label.textColor = HIGHTEDCOLOR;
            break;
        default:
            break;
    }
}
- (void)setSeletedIndexPath:(NSInteger)seletedIndexPath
{
    if (_seletedIndexPath == seletedIndexPath) return;
    _seletedIndexPath = seletedIndexPath;
    [self setItemsSeletedState];
    CGPoint point = CGPointZero;
    switch (seletedIndexPath) {
        case 0:
            point = CGPointMake(_leftItem.center.x - 20, _leftItem.center.y * 2);
            break;
        case 1:
            point = CGPointMake(_rightItem.center.x - 20, _rightItem.center.y * 2);
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.center = point;
    }];
}
- (void)setFinds:(NSString *)finds fav:(NSString *)fav
{
    _leftItem.label.text = finds;
    _rightItem.label.text = fav;
}
@end
