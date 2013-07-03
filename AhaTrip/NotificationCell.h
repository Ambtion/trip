//
//  NotificationCell.h
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"

@class NotificationCell;
@interface NotificationCellDataSource : NSObject
@property(nonatomic,strong)UIImage * portraitImage;
@property(nonatomic,strong)NSString * name;
@end
@interface NotificationCell : UITableViewCell
{
    PortraitView * portraitImageView;
    
}
@end
