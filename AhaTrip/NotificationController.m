//
//  NotificationController.m
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "NotificationController.h"
@interface NotificationController ()
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation NotificationController
@synthesize dataSource = _dataSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCusNavBar];
    [self addTableView];
}
- (void)addCusNavBar
{
    UIImageView * bar_bg_View = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    bar_bg_View.image = [UIImage imageNamed:@"notification_bar_bg.png"];
    [self.view addSubview:bar_bg_View];
    [bar_bg_View setUserInteractionEnabled:YES];
    UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(7, 7, 30, 30);
    leftbutton.tag = 100;
    [leftbutton setImage:[UIImage imageNamed:@"ItemMenuBarBg-white.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(menuLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar_bg_View addSubview:leftbutton];
}
- (void)addTableView
{
    _tableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    [self refresFromeNetWork];
    
}
#pragma mark TableViewData
- (void)pullingreloadTableViewDataSource:(id)sender
{
    [self refresFromeNetWork];
}
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self getMoreFromeNetWork];
}
- (void)refresFromeNetWork
{
    [_dataSource removeAllObjects];
    for (int i = 0; i < 20; i++) {
        NotificationCellDataSource * source = [[NotificationCellDataSource alloc] init];
        source.portrait = [UIImage imageNamed:@"testPor.png"];
        source.name = @"Erfei_Chao";
        source.content = @"嗷嗷！包装好喜欢！多少钱啊？?";
        source.target = @"评论我的发现";
        source.targetName = @"奈良のIceCream";
        source.time = @"05-19 22:50";
        [_dataSource addObject:source];

        SysNotificationCellDataSource * sysSource = [[SysNotificationCellDataSource alloc] init];
        sysSource.portrait = [UIImage imageNamed:@"testPor.png"];
        sysSource.name = @"AHaTrip";
        sysSource.content = @"敢问这位朋友，AhaTrip的客户端使用 得如何？求点评求拍砖求鞭策！......在 设置-意见反馈中告诉我们,求点评求拍砖求鞭,求点评求拍砖求鞭,求点评求拍砖求鞭";
        sysSource.time = @"05-19 22:50";
        [_dataSource addObject:sysSource];
    }
    [_tableView reloadData];
    [_tableView didFinishedLoadingTableViewData];
    
}
- (void)getMoreFromeNetWork
{
    //    for (int i = 0; i < 10; i++) {
    //        PlazeCellDataSource * source = [[PlazeCellDataSource alloc] init];
    //        source.leftInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    //        source.rightInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    //        [_assetsArray addObject:source];
    //    }
    //    [_tableView reloadData];
    [_tableView didFinishedLoadingTableViewData];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SysNotificationCellDataSource * souce = [_dataSource objectAtIndex:indexPath.row];
    return [souce heigth];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1.f];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * sys_string = @"CELL_SYS";
    static NSString * user_string = @"CELL_USER";
    id dataSouce = nil;
    if (indexPath.row <_dataSource.count)
        dataSouce = [_dataSource objectAtIndex:indexPath.row];
    if (dataSouce) {
        if ([dataSouce isKindOfClass:[NotificationCellDataSource class]]) {
            NotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:user_string];
            if (!cell) {
                cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:user_string];
            }
            cell.dataSource = dataSouce;
            return cell;
        }else{
            SysNotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:sys_string];
            if (!cell) {
                cell = [[SysNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sys_string];
            }
            cell.dataSource = dataSouce;
            return cell;
        }
    }
    return nil;
}


#pragma mark Action
- (void)menuLeftClick:(UIButton *)button
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}
@end
