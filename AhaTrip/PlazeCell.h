//
//  PlazeCell.h
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlazeCell;
@interface  PlazeCellDataSource:NSObject
@property(nonatomic,strong)NSDictionary *  leftInfo;
@property(nonatomic,strong)NSDictionary *  rightInfo;
+ (CGFloat)cellHight;
@end

@protocol PlazeCellDelegate <NSObject>
- (void)PlazeCell:(PlazeCell *)photoCell clickCoverGroup:(NSDictionary *)info;
@end

@interface PlazeCell : UITableViewCell
{
    UIImageView * _leftImageView;
    UIImageView * _rightImageView;
    PlazeCellDataSource * _dataSource;
}
@property(nonatomic,strong)PlazeCellDataSource * dataSource;
@property(nonatomic,weak)id<PlazeCellDelegate> delegate;
@end
