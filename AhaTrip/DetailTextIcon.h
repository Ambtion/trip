//
//  DetailTextIcon.h
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DesInfoViewDataSource : NSObject
@property(nonatomic,strong)NSString * averConsume;
@property(nonatomic,strong)NSString * businessTime;
@property(nonatomic,strong)NSString * netHasWifi;
@property(nonatomic,strong)UIImage *  sortImage;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,strong)NSString * desString;
@property(nonatomic,strong)NSString * location;
@end

@class MaskView;
@interface DetailTextIconDataSource : NSObject

@end
@interface MoreInfoView : UIImageView
{
    UILabel * _titleLabel;
    UIView * _maskView;
}

@property(nonatomic,strong)UILabel * averConsume;
@property(nonatomic,strong)UILabel * businessTime;
@property(nonatomic,strong)UILabel * netHasWifi;
@end

@interface DesInfoView : UIImageView
{
    UIImageView * _locationIcon;
    CGSize actualSize;
}
@property(nonatomic,strong) UIImageView * sortImageView;
@property(nonatomic,strong) UILabel * userNameLabel;
@property(nonatomic,strong) UILabel * desLabel;
@property(nonatomic,strong) UILabel * locationLabel;
- (void)layoutAllViews;
- (CGSize)actualSize;
@end

@class DetailTextIcon;
@protocol DetailTextIconAnimationDelegate <NSObject>
- (void)detailTextIconShowAnimationDidFinished:(DetailTextIcon *)icon;
- (void)detailTextIconHiddenAnimationDidFinished:(DetailTextIcon *)icon;
@end
@interface DetailTextIcon : NSObject
{
    __weak UIView * _superView;
    MaskView * _maskView;
    UIButton * _iconButton;
    DesInfoView * _desInfoView;
    MoreInfoView * _moreInfoView;
    DesInfoViewDataSource* _datasoure;
}
- (id)initWithView:(UIView *)view;
@property(nonatomic,weak)id<DetailTextIconAnimationDelegate> delegate;
@property(nonatomic,strong)DesInfoViewDataSource * datasoure;
@end
