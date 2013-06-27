//
//  DetailTextIcon.m
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "DetailTextIcon.h"
#import <QuartzCore/QuartzCore.h>

@interface MaskView:UIView
@property(nonatomic,weak)id menuObject;
@end

@implementation MaskView
@synthesize menuObject;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:NO];
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touched = [[touches anyObject] view];
    if (touched == self) {

    }
}

@end

#define OFFSETX 12

@implementation MoreInfoView

@synthesize averConsume = _averConsume;
@synthesize businessTime = _businessTime;
@synthesize netHasWifi = _netHasWifi;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 310.f;
    frame.size.height = 90.f;
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImage imageNamed:@"DetailMoreInfo_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        self.clipsToBounds = YES;
        CGRect rect = self.bounds;
        rect.size.height -=12;
        _maskView = [[UIView alloc] initWithFrame:rect];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.clipsToBounds = YES;
        [self addSubview:_maskView];
        [self addTitleLabel];
        [self addAverConsume];
        [self addBusinesstimeLabel];
        [self addNetHasWifiLabel];
    }
    return self;
}
- (void)addTitleLabel
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(OFFSETX, 0, 100, 30)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"更多信息";
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    [_maskView addSubview:_titleLabel];
}
- (void)addAverConsume
{
    UILabel * consumeTitle = [[UILabel alloc] initWithFrame:CGRectMake(OFFSETX, 36, 60, 14)];
    consumeTitle.textColor = [UIColor whiteColor];
    consumeTitle.backgroundColor = [UIColor clearColor];
    consumeTitle.text = @"人均消费：";
    consumeTitle.font = [UIFont systemFontOfSize:12.f];
    [_maskView addSubview:consumeTitle];

    self.averConsume = [[UILabel alloc] initWithFrame:CGRectMake(consumeTitle.frame.size.width+consumeTitle.frame.origin.x, consumeTitle.frame.origin.y, 83, 14)];
    self.averConsume.backgroundColor = [UIColor clearColor];
    self.averConsume.textColor = [UIColor whiteColor];
    self.averConsume.font = [UIFont systemFontOfSize:12.f];
    [_maskView addSubview:self.averConsume];
//    self.averConsume.text = @"300日元";

}
- (void)addBusinesstimeLabel
{
    UILabel * bustitle = [[UILabel alloc] initWithFrame:CGRectMake(155 + OFFSETX, 36, 60, 14)];
    bustitle.textColor = [UIColor whiteColor];
    bustitle.backgroundColor = [UIColor clearColor];
    bustitle.text = @"营业时间：";
    bustitle.font = [UIFont systemFontOfSize:12.f];
    [_maskView addSubview:bustitle];
    
    self.businessTime = [[UILabel alloc] initWithFrame:CGRectMake(bustitle.frame.size.width + bustitle.frame.origin.x, bustitle.frame.origin.y, 83, 14)];
    self.businessTime.backgroundColor = [UIColor clearColor];
    self.businessTime.textColor = [UIColor whiteColor];
    self.businessTime.font = [UIFont systemFontOfSize:12.f];
    [_maskView addSubview:self.businessTime];
//    self.businessTime.text = @"6:00--10:00";
    
}

- (void)addNetHasWifiLabel
{
    UILabel * wifiTitle = [[UILabel alloc] initWithFrame:CGRectMake(OFFSETX, 53, 60, 14)];
    wifiTitle.textColor = [UIColor whiteColor];
    wifiTitle.backgroundColor = [UIColor clearColor];
    wifiTitle.text = @"Wi-Fi：";
    wifiTitle.font = [UIFont systemFontOfSize:12.f];
    [_maskView addSubview:wifiTitle];
    
    self.netHasWifi = [[UILabel alloc] initWithFrame:CGRectMake(wifiTitle.frame.size.width + wifiTitle.frame.origin.x, wifiTitle.frame.origin.y, 83, 14)];
    self.netHasWifi.backgroundColor = [UIColor clearColor];
    self.netHasWifi.textColor = [UIColor whiteColor];
    self.netHasWifi.font = [UIFont systemFontOfSize:12.f];
    [_maskView addSubview:self.netHasWifi];
//    self.netHasWifi.text = @"无";
    
}

@end
@implementation DesInfoViewDataSource
@synthesize averConsume,businessTime,netHasWifi,sortImage,userName,desString,location;
@end

@implementation DesInfoView
@synthesize userNameLabel = _userNameLabel,desLabel = _desLabel,locationLabel = _locationLabel;
@synthesize sortImageView = _sortImageView;

- (id)initWithFrame:(CGRect)frame
{
    frame.size.width = 310;
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImage imageNamed:@"DetailDes_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 0, 0, 5)];
        self.clipsToBounds = YES;
        [self addUserNameLabel];
        [self adduserDesLabel];
        [self addUserLocationLabel];
    }
    return self;
}
- (void)addUserNameLabel
{
    //39 - 25
    _sortImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OFFSETX, (40 - 26)/2.f, 26, 26)];
    _sortImageView.backgroundColor = [UIColor redColor];
    _sortImageView.layer.cornerRadius = 13.f;
    [self addSubview:_sortImageView];
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(OFFSETX * 2 + _sortImageView.frame.size.width, 0, 310 - (OFFSETX * 3 + _sortImageView.frame.size.width), 40)];
    self.userNameLabel.backgroundColor = [UIColor clearColor];
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.font = [UIFont systemFontOfSize:16.f];
//    self.userNameLabel.text = @"奈良のIceCream";
    [self addSubview:self.userNameLabel];
    
}
- (void)adduserDesLabel
{
    self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(OFFSETX, 45, 0, 0)];
    self.desLabel.backgroundColor = [UIColor clearColor];
    self.desLabel.numberOfLines = 0;
    self.desLabel.textColor = [UIColor whiteColor];
    self.desLabel.font = [UIFont systemFontOfSize:13.f];
//    self.desLabel.text = @"奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream,奈良のIceCream";
    [self addSubview:self.desLabel];
}
- (void)addUserLocationLabel
{
  
    _locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LocationIcon.png"]];
    _locationIcon.backgroundColor = [UIColor clearColor];
    [self addSubview:_locationIcon];
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.textColor = [UIColor colorWithRed:43/255.f green:221/255.f blue:170/255.f alpha:1.f];
    self.locationLabel.font = [UIFont systemFontOfSize:11.f];
//    self.locationLabel.text = @"日本奈良県奈良市南市町20番";
    [self addSubview:self.locationLabel];
}
- (void)layoutAllViews
{

    _sortImageView.frame = CGRectMake(OFFSETX, (40 - 26)/2.f, 26, 26);
    self.userNameLabel.frame = CGRectMake(OFFSETX * 2 + _sortImageView.frame.size.width, 0, 310 - (OFFSETX * 3 + _sortImageView.frame.size.width), 40);
    NSLog(@"usenaml %@ %@",self.userNameLabel.text,NSStringFromCGRect(self.userNameLabel.frame));
    //des_Frame
    CGSize desSize = [self sizeofLabel:self.desLabel];
    CGRect rect  = CGRectMake(self.desLabel.frame.origin.x, self.desLabel.frame.origin.y, desSize.width, desSize.height);
    self.desLabel.frame = rect;
    NSLog(@"des %@ %@",self.desLabel.text,NSStringFromCGRect(self.desLabel.frame));

    //location Frame 间隔8
    _locationIcon.frame = CGRectMake(OFFSETX, self.desLabel.frame.origin.y + self.desLabel.frame.size.height + 8, 15, 15);
    
    //location由于字间距,上调一像素
    
    self.locationLabel.frame = CGRectMake(OFFSETX + 15 + 5 , _locationIcon.frame.origin.y - 1, 310 -(OFFSETX + 15 + 5 + OFFSETX) , 15);
    //self frame  向下12px
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 310, _locationIcon.frame.size.height + _locationIcon.frame.origin.y + 12);
    NSLog(@"self %@ %@",self.locationLabel.text,NSStringFromCGRect(self.frame));

    actualSize = self.frame.size;
}
- (CGSize)sizeofLabel:(UILabel *)label
{
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(310 - 2 * OFFSETX, 1000) lineBreakMode:label.lineBreakMode];
}
- (CGSize)actualSize
{
    return actualSize;
}
@end

@implementation DetailTextIcon
@synthesize delegate = _delegate;

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        
        _superView = view;
        _maskView = [[MaskView alloc] initWithFrame:view.bounds];
        [_superView addSubview:_maskView];
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconButton setImage:[UIImage imageNamed:@"DetailIcon_Bg.png"] forState:UIControlStateNormal];
        [_iconButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _iconButton.frame = CGRectMake(25, _maskView.bounds.size.height - 65, 35,35);
        [_superView addSubview:_iconButton];
        
        _moreInfoView = [[MoreInfoView alloc] initWithFrame:CGRectZero];
        [_maskView addSubview:_moreInfoView];
        
        _desInfoView = [[DesInfoView alloc] initWithFrame:CGRectMake(0, 200, 20, 0)];
        [_maskView addSubview:_desInfoView];
        [self layoutDetailViews];
        [self hideDetailTextWithAnimation:NO];
    }
    return self;
}

- (void)buttonClick:(UIButton *)button
{
    if (button.tag) {
        [self hideDetailTextWithAnimation:YES];
    }else{
        [self showDetailTextWithAnimation];
    }
    button.tag = !button.tag;
}
#pragma mark DataSoure
- (DesInfoViewDataSource *)desDatasoure
{
    return _datasoure;
}
- (void)setDatasoure:(DesInfoViewDataSource *)datasoure
{
    if (_datasoure != datasoure) {
        _datasoure = datasoure;
        [self upViewsData];
        [self layoutDetailViews];
        [self hideDetailTextWithAnimation:NO];
    }
}
#pragma mark layoutViews
- (void)upViewsData
{
    _moreInfoView.averConsume.text = [_datasoure averConsume];
    _moreInfoView.businessTime.text  = [_datasoure businessTime];
    _moreInfoView.netHasWifi.text = [_datasoure netHasWifi];
    _desInfoView.sortImageView.image = [_datasoure sortImage];
    _desInfoView.userNameLabel.text = [_datasoure userName];
    _desInfoView.desLabel.text = [_datasoure desString];
    _desInfoView.locationLabel.text  =[_datasoure location];
    
}
- (void)layoutDetailViews
{
    //Icon
    _iconButton.frame = CGRectMake(20, _superView.bounds.size.height - 65, 35,35);
    //More
    CGRect moreRect = _moreInfoView.frame;
    moreRect.origin.x = 5;
    moreRect.origin.y = _iconButton.frame.origin.y - _moreInfoView.frame.size.height - 2; //2px offset
    _moreInfoView.frame = moreRect;
    //Detail
    [_desInfoView layoutAllViews];
    NSLog(@"LLL::%@",NSStringFromCGRect(_desInfoView.frame));
    CGRect detailRect = _desInfoView.frame;
    detailRect.origin.x = 5;
    detailRect.origin.y = _moreInfoView.frame.origin.y - detailRect.size.height - 5.f;
    _desInfoView.frame = detailRect;
}

- (void)showDetailTextWithAnimation
{
        CGRect moreRect = _moreInfoView.frame;
        moreRect.size.width = 310.f;
        moreRect.size.height = 90.f;
        moreRect.origin.x = 5;
        moreRect.origin.y = _iconButton.frame.origin.y - moreRect.size.height - 2; //2px offset
        _moreInfoView.frame  = CGRectMake(moreRect.origin.x, moreRect.origin.y +  moreRect.size.height + 2, 0, 0);
        [UIView animateWithDuration:0.3 animations:^{
            _moreInfoView.frame = moreRect;
        } completion:^(BOOL finished) {
            CGRect detailRect = _desInfoView.frame;
            detailRect.size.width = [_desInfoView actualSize].width;
            detailRect.size.height = [_desInfoView actualSize].height;
            detailRect.origin.x = 5;
            detailRect.origin.y = _moreInfoView.frame.origin.y - detailRect.size.height - 5.f;
            _desInfoView.frame  = CGRectMake(detailRect.origin.x, detailRect.origin.y + detailRect.size.height, 0, 0);
            [UIView animateWithDuration:0.5 animations:^{
                _desInfoView.frame = detailRect;
            } completion:^(BOOL finished) {
                if ([_delegate respondsToSelector:@selector(detailTextIconShowAnimationDidFinished:)]) {
                    [_delegate detailTextIconShowAnimationDidFinished:self];
                }
            }];
        }];
}
- (void)hideDetailTextWithAnimation:(BOOL)animation
{
    if (animation) {
        CGRect desRect = _desInfoView.frame;
        desRect.origin.y = desRect.origin.y + desRect.size.height;
        desRect.size.height = 0.f;
        desRect.size.width = 0.f;
        [UIView animateWithDuration:0.3 animations:^{
            _desInfoView.frame = desRect;
        } completion:^(BOOL finished) {
            CGRect moreRect = _moreInfoView.frame;
            moreRect.origin.y = moreRect.origin.y + moreRect.size.height;
            moreRect.size.height = 0.f;
            moreRect.size.width = 0.f;
            moreRect.origin.x = 37.f;
            [UIView animateWithDuration:0.3 animations:^{
                _moreInfoView.frame = moreRect;
            } completion:^(BOOL finished) {
                if ([_delegate respondsToSelector:@selector(detailTextIconHiddenAnimationDidFinished:)]) {
                    [_delegate detailTextIconHiddenAnimationDidFinished:self];
                }
            }];
        }];
    }else{
        CGRect desRect = _desInfoView.frame;
        desRect.origin.y = desRect.origin.y + desRect.size.width;
        desRect.size.height = 0.f;
        desRect.size.width = 0.f;        
        _desInfoView.frame = desRect;
        
        CGRect moreRect = _moreInfoView.frame;
        moreRect.origin.y = moreRect.origin.y + moreRect.size.width;
        moreRect.size.height = 0.f;
        moreRect.size.width = 0.f;
        _moreInfoView.frame = moreRect;
    }
}
@end

