//
//  DetailsViewController.h
//  XQSearchPlaces
//
//  Created by iObitLXF on 5/20/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceDetailVO.h"
@interface DetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *myNavItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)PlaceDetailVO   *placeDetailVO;
@end
