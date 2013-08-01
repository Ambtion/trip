//
//  SouSuoViewController.h
//  Trip
//
//  Created by xuwenjuan on 13-6-13.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SouSuoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*cityTable;
    NSMutableArray*cityArr;
    UIImageView*bottomBar;
    int height;
    
}

@property(nonatomic,strong)NSString*selectCAtegary;
@end
