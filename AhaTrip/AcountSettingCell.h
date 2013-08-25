//
//  AcountSettingCell.h
//  AhaTrip
//
//  Created by sohu on 13-7-4.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"
#import "BirthDayField.h"

@class AcountSettingCell;
@protocol AcountSettingCellDelegate <NSObject>
- (void)acountSettingCell:(AcountSettingCell*)cell changeImage:(UIButton *)button;
- (void)acountSettingCellDidBeginEdit:(AcountSettingCell*)cell;
@optional
- (void)acountSettingCellDidFinishedEdit:(AcountSettingCell*)cell;
@end
@interface AcountSettingCellDataSource : NSObject
@property(nonatomic,strong)NSString * poraitImage;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,strong)NSString * userDes;
@property(nonatomic,strong)NSString * birthday;
@property(nonatomic,strong)NSString * sex;
+ (CGFloat)heigth;
- (NSDictionary *)userInfo;
@end
@interface AcountSettingCell : UITableViewCell<UITextFieldDelegate>
{
    PortraitView * _portraitImage;
    UITextField * _userNameLabel;
    UITextField * _userDes;
    BirthDayField * _birthday;
    AcountSettingCellDataSource * _dataSouce;
}
@property(nonatomic,weak)id<AcountSettingCellDelegate> delegate;
@property(nonatomic,strong)AcountSettingCellDataSource * dataSouce;
@property(nonatomic,strong)PortraitView * portraitImage;
@property(nonatomic,strong)UITextField * userNameLabel;
@property(nonatomic,strong)UITextField * userDes;
@property(nonatomic,strong)BirthDayField * birthday;

- (void)updataAllViews;
@end
