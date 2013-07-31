//
//  HomePageController.m
//  AhaTrip
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "HomePageController.h"
#import "RequestManager.h"

@interface HomePageController ()
@property(nonatomic,strong)NSMutableArray * assetsArray;
@property(nonatomic,strong)NSMutableArray * dataSourceArray;
@end
@implementation HomePageController
@synthesize assetsArray = _assetsArray;
@synthesize dataSourceArray = _dataSourceArray;

- (id)initAsRootViewController:(BOOL)isRoot withUserId:(NSString *)userId
{
    if (self = [super init]) {
        _isRootController = isRoot;
        _userId = userId;
        _isFinds = YES;
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
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setContentMode:UIViewContentModeScaleAspectFit];
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
    _tableView.backgroundColor = [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:1.f];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _assetsArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    _homeAccountPage = [[HomeAccountPage alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [_homeAccountPage addTarget:self action:@selector(homesegClick:) forControlEvents:UIControlEventValueChanged];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 225.f)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:_homeAccountPage];
    _tableView.tableHeaderView = view;
    [self refresFromeNetWork];
}
#pragma mark SegmentControll
- (void)homesegClick:(HomeSegMent *)sender
{
    _isFinds = !sender.seletedIndexPath;
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
- (void)getUserInfo
{
    [RequestManager getUserInfoWithUserId:_userId token:nil success:^(NSString *response) {
        DLog(@"LLLLL");
        NSDictionary * dic = [[response JSONValue] objectForKey:@"user"];
        DLog(@"%@",dic);
        HomeAccountPageDataSource * source = [[HomeAccountPageDataSource alloc] init];
        source.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"username"]];
        source.portraitUrl =[dic objectForKey:@"thumb"];
        source.descrip = [NSString stringWithFormat:@"%@",[dic objectForKey:@"signature"]];
        source.finds = [[dic objectForKey:@"finding_count"] integerValue];
        source.favorite = [[dic objectForKey:@"favorite_count"] integerValue];
        _homeAccountPage.dataSource = source;
    } failure:^(NSString *error) {
        
    }];
}
- (void)refresFromeNetWork
{
    [self getUserInfo];
    if (_isFinds) {
        [RequestManager getFindsUserId:_userId Withstart:0 count:20 token:nil success:^(NSString *response) {
            [_assetsArray removeAllObjects];
            [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
            [self convertAssetsToDataSouce];

        } failure:^(NSString *error) {
            
        }];
    }else{
        [RequestManager getFavUserId:_userId Withstart:0 count:20 token:nil success:^(NSString *response) {
            [_assetsArray removeAllObjects];
            [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
            [self convertAssetsToDataSouce];
        } failure:^(NSString *error) {
            
        }];
    }
}
- (void)getMoreFromeNetWork
{
    if (_assetsArray.count % 20){
        [_tableView didFinishedLoadingTableViewData];
        return;
    }
    if (_isFinds) {
        [RequestManager getFindsUserId:_userId Withstart:_assetsArray.count count:20 token:nil success:^(NSString *response) {
            [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
            [self convertAssetsToDataSouce];
            DLog(@"%@",[response JSONValue]);
        } failure:^(NSString *error) {
            
        }];
    }else{
        [RequestManager getFavUserId:_userId Withstart:0 count:20 token:nil success:^(NSString *response) {
            [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
            [self convertAssetsToDataSouce];
            DLog(@"%@",[response JSONValue]);
        } failure:^(NSString *error) {
            
        }];

    }
}
- (void)convertAssetsToDataSouce
{
    [_dataSourceArray removeAllObjects];
    DLog(@"%@",[_assetsArray lastObject]);
    for (int i = 0;i < _assetsArray.count ; i+=2) {
        PlazeCellDataSource * source = [[PlazeCellDataSource alloc] init];
        source.leftInfo = [_assetsArray objectAtIndex:i];
        if (i + 1 < _assetsArray.count) {
            source.rightInfo = [_assetsArray objectAtIndex:i+1];
        }
        [_dataSourceArray addObject:source];
    }
    [_tableView reloadData];
    [_tableView didFinishedLoadingTableViewData];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
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
    cell.dataSource = [_dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - AweSomeMenuDelegate
- (void)PlazeCell:(PlazeCell *)photoCell clickCoverGroup:(NSDictionary *)info
{
    [self.navigationController pushViewController:[[PhotoDetailController alloc] initWithTitleId:[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]]] animated:YES];
}
@end
