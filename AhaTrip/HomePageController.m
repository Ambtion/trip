//
//  HomePageController.m
//  AhaTrip
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "HomePageController.h"
@interface HomePageController ()
@property(nonatomic,strong)NSMutableArray * assetsArray;
@end
@implementation HomePageController
@synthesize assetsArray = _assetsArray;
- (id)initAsRootViewController:(BOOL)isRoot
{
    if (self = [super init]) {
        _isRootController = isRoot;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTableView];
    [self addBackButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    self.viewDeckController.delegate = nil;
    self.viewDeckController.rightController = nil;
}

- (void)addBackButton
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(7, 7, 30, 30);
    if (_isRootController) 
        [backButton setImage:[UIImage imageNamed:@"ItemMenuBarBg-white.png"] forState:UIControlStateNormal];
    else
        [backButton setImage:[UIImage imageNamed:@"back_Button.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
//    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(320 - 44, 7, 30, 30);
//    [rightButton setImage:[UIImage imageNamed:@"ItemSearchBarBg-white.png"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:rightButton];
}

- (void)backButtonClick:(UIButton *)button
{
    if (_isRootController)
        [self.viewDeckController toggleLeftViewAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
//- (void)searchButtonClick:(UIButton*)button
//{
//    [self.viewDeckController toggleRightViewAnimated:YES];
//}
#pragma mark TableView
- (void)addTableView
{
    _tableView = [[EGRefreshTableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _assetsArray = [[NSMutableArray alloc] initWithCapacity:0];
    _homeAccountPage = [[HomeAccountPage alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 225.f)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:_homeAccountPage];
    _tableView.tableHeaderView = view;
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
    [_assetsArray removeAllObjects];
    for (int i = 0; i < 20; i++) {
        PlazeCellDataSource * source = [[PlazeCellDataSource alloc] init];
        source.leftInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        source.rightInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [_assetsArray addObject:source];
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
    return _assetsArray.count;
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
        cell.delegate = self;
    }
    cell.dataSource = [_assetsArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - AweSomeMenuDelegate
- (void)PlazeCell:(PlazeCell *)photoCell clickCoverGroup:(NSDictionary *)info
{
    [self.navigationController pushViewController:[[PhotoDetailController alloc] init] animated:YES];
}
@end
