//
//  NotificationController.m
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "NotificationController.h"
#import "RequestManager.h"

@interface NotificationController ()
@property(nonatomic,strong)NSMutableArray * dataSource;
@end

@implementation NotificationController
@synthesize dataSource = _dataSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1.f];

    [self addCusNavBar];
    [self addTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    self.viewDeckController.delegate = nil;
    self.viewDeckController.rightController = nil;
    [self getMoreFromeNetWork];
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
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = nil;
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
    [RequestManager getNotificationListSuccess:^(NSString *response) {
        [self addSourceWithArrayInfo:[[response JSONValue] objectForKey:@"messages"]];
        [_tableView reloadData];
        [_tableView didFinishedLoadingTableViewData];
    } failure:^(NSString *error) {
        [_tableView reloadData];
        [_tableView didFinishedLoadingTableViewData];
    }];
}
- (void)addSourceWithArrayInfo:(NSArray *)array
{
    [_dataSource removeAllObjects];
    DLog(@"SSS$%@",array);
    for (NSDictionary * info in array) {
        id source = [self getSourceWithInfo:info];
        if (source) {
            [_dataSource addObject:source];
        }
    }
    DLog(@"%d",_dataSource.count);
}
- (id)getSourceWithInfo:(NSDictionary *)info
{
    if (![[info objectForKey:@"target"] isEqualToString:@"systerm"]) {
        DLog(@"MMMMMM");
        NotificationCellDataSource * source = [[NotificationCellDataSource alloc] init];
        source.portrait = [info objectForKey:@"from_user_photo"];
        source.content = [info objectForKey:@"content"];
        source.target = [info objectForKey:@"target"];
        source.name = [info objectForKey:@"from_username"];
        source.targetName = [info objectForKey:@"target_content"];
        source.time = [info objectForKey:@"time"];
        source.findId = [[info objectForKey:@"finding_id"] integerValue];
        return source;
    }else{
        SysNotificationCellDataSource * sysSource = [[SysNotificationCellDataSource alloc] init];
        sysSource.portrait = [info objectForKey:@"from_user_photo"];
        sysSource.name = [info objectForKey:@"from_username"];
        sysSource.content = [info objectForKey:@"content"];
        sysSource.time = [info objectForKey:@"time"];
        return sysSource;
    }
    return nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[NotificationCell class]]) {
//        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[[CommentController alloc] initWithBgImage:[UIImage imageNamed:@"test2.jpg"] findsID:0]];
//        [nav.navigationBar setHidden:YES];
//        [self presentModalViewController:nav animated:YES];
//    }
        [self.navigationController pushViewController:[[PhotoDetailController alloc] initWithTitleId:[NSString stringWithFormat:@"%d",((NotificationCell *)cell).dataSource.findId]] animated:YES];

    }
}

@end
