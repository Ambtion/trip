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
    [self showLoginViewWithMethodNav:YES withAnimation:YES];
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
        PlazeCellDataSource * source = [[PlazeCellDataSource alloc] init];
        source.leftInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        source.rightInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [_dataSource addObject:source];
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
    return [PlazeCellDataSource cellHight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"CELL";
    PlazeCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[PlazeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
//        cell.delegate = self;
    }
    cell.dataSource = [_dataSource objectAtIndex:indexPath.row];
    return cell;
}

@end
