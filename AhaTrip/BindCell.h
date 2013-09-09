//
//  BindCell.h
//  AhaTrip
//
//  Created by sohu on 13-7-4.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BindCell;
@protocol BindCellDelegate <NSObject>
- (void)BindCell:(BindCell*)cell SwithChanged:(UISwitch *)bindSwitch;
@end
@interface BindCell : UITableViewCell
@property(nonatomic,weak)id<BindCellDelegate> delegate;
@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UISwitch * bindSwitch;
@property(nonatomic,strong)UIImageView * lineView;
@end
