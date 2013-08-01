//
//  CenterViewController.h
//  Trip
//
//  Created by xuwenjuan on 13-6-13.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadCurveMenu.h"
#import "JASidePanelController.h"
@interface CenterViewController :UIViewController<UITableViewDelegate,UITableViewDataSource,QuadCurveMenuDelegate>
{
    UITableView*photoTable;
    BOOL isTop;
    NSMutableArray*menuArr;
}
@property(nonatomic,strong)NSString*countryName;
@end
