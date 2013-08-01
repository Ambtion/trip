//
//  SingleMenuViewController.h
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView*departmentTable;
    NSMutableArray*departMentArr;
    UIImageView*bottomBar;

}
@property(nonatomic,strong)NSString*menuStr;
@property(nonatomic,assign)int selectID;
@end
