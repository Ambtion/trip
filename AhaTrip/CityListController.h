//
//  CityTwoViewController.h
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityListControllerDelegate <NSObject>
- (void)cityListControllerDidSeletedCityInfo:(NSDictionary *)info;
@end
@interface CityListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * singlecityTable;
    NSMutableArray * singleCityArr;
    UIImageView * bottomBar;
    int height;
}
@property(nonatomic,assign)id<CityListControllerDelegate> delegate;
@property(nonatomic,strong)NSDictionary * countryInfo;
@end
