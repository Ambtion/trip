//
//  CityTwoViewController.h
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTwoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*singlecityTable;
    NSMutableArray*singleCityArr;
    UIImageView*bottomBar;
    int height;
}
@property(nonatomic,strong)NSString*singleCityId;
@property(nonatomic,strong)NSString*singleCityName;
@property(nonatomic,strong)NSString*singleCityName1;
@property(nonatomic,strong)NSString*cateryStr;
@end
