//
//  CityListCell.h
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryListCellDataSource : NSObject
@property(nonatomic,strong)id identify;
@property(nonatomic,strong)NSString * cName;
@property(nonatomic,strong)NSString * eName;
@end

@interface CountryListCell : UITableViewCell
{
    UILabel * _cNameLabel;
    UILabel * _eNameLabel;
    UIImageView * arrow;
    CountryListCellDataSource * _dataSource;
    CGFloat _offset;
}
@property(nonatomic,strong)CountryListCellDataSource * dataSource;
@property(nonatomic,strong)UIImageView * arrow;
- (void)setoffset:(CGFloat)offset;
@end
