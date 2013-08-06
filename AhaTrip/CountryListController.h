//
//  SouSuoViewController.h
//  Trip
//
//  Created by xuwenjuan on 13-6-13.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountryListViewDelegate <NSObject>
- (void)countryListControllerSeletedCountry:(NSDictionary*)countryInfo;
@end
@interface CountryListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * countryTable;
    NSMutableArray * countryArray;
    UIImageView*bottomBar;
    int height;
}
@property(nonatomic,assign)id<CountryListViewDelegate> delegate;
@end
