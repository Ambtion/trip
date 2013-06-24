//
//  LeftMenuCell.h
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"
#import "CountLabel.h" 


@interface LeftMenuCell : UITableViewCell

@property(nonatomic,strong)PortraitView *iconImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)CountLabel * countLabel;
@end
