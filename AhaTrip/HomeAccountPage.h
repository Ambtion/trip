//
//  HomeAccountPage.h
//  AhaTrip
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSegMent.h"
#import "PortraitView.h"

@class HomeAccountPage;
@interface HomeAccountPageDataSource : NSObject
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * portraitUrl;
@property(nonatomic,strong)NSString * descrip;
@property(nonatomic,assign)NSInteger finds;
@property(nonatomic,assign)NSInteger favorite;
@end

@interface HomeAccountPage : UIView
{
 
    UIImageView * _bgImageView;
    PortraitView* _portraitImageView;
    UILabel * _nameLabel;
    UILabel * _desLabel;
    HomeSegMent * _segMent;
    HomeAccountPageDataSource * _dataSource;
}
@property(nonatomic,strong)HomeAccountPageDataSource * dataSource;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
