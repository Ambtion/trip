//
//  RightSerachController.m
//  AhaTrip
//
//  Created by Qu on 13-6-23.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "RightSerachController.h"
#import "CountryListCell.h"
#import "CityViewController.h"
#import "SearchPlazaViewController.h"

#define ALLCOUNTRY          @"全部"
#define OTHERCOUNTRY        @"其他国家/地区"

@implementation CusSearchDisplayController
- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
    if(self.active == visible) return;
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    if (visible) {
        [self.searchBar becomeFirstResponder];
    } else {
        [self.searchBar resignFirstResponder];
    }
}
@end

@interface RightSerachController()
@property(nonatomic,strong)NSMutableArray * sourceArray;
@property(nonatomic,strong)NSMutableArray * searchSourceArray;
@end
@implementation RightSerachController
@synthesize sourceArray = _sourceArray;
@synthesize searchSourceArray = _searchSourceArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wantsFullScreenLayout = YES;
    self.view.backgroundColor = [UIColor blackColor];
    _tableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(44, 0, 276, self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [self getViewWithstr:OTHERCOUNTRY];
    [self.view addSubview:_tableView];
    [self addSearchView];
    [self initDataContainer];
    [self refrehsFromNetWork];
}
- (void)addSearchView
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.barStyle = UIBarStyleBlack;
    _searchBar.placeholder = @" ";
    [_searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"search_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)]forState:UIControlStateNormal];
    [_searchBar setImage:[UIImage imageNamed:@"search_Icon.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    _tableView.tableHeaderView = _searchBar;
    _searchDisPlay = [[CusSearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisPlay.searchResultsDelegate = self;
    _searchDisPlay.searchResultsDataSource = self;
    _searchDisPlay.delegate = self;
}
- (UIView *)getViewWithstr:(NSString *)str
{
    CountryListCellDataSource * otherSouece = [[CountryListCellDataSource alloc] init];
    otherSouece.cName = str;
    otherSouece.eName = nil;
    CountryListCell * other = [[CountryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    other.dataSource = otherSouece;
    UIView * view = [other getBgView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [view addGestureRecognizer:gesture];
    return view;
}

- (void)initDataContainer
{
    _sourceArray = [NSMutableArray arrayWithCapacity:0];
    _searchSourceArray = [NSMutableArray arrayWithCapacity:0];
}
#pragma mark Data
- (void)pullingreloadTableViewDataSource:(id)sender
{
    [self refrehsFromNetWork];
}
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [_tableView didFinishedLoadingTableViewData];
}
- (void)refrehsFromNetWork
{
    [RequestManager getCountryListWithstart:0 count:20 token:nil success:^(NSString *response) {
        DLog(@"%@",[response JSONValue]); 
        [_sourceArray removeAllObjects];
        CountryListCellDataSource * otherSouece = [[CountryListCellDataSource alloc] init];
        otherSouece.cName = ALLCOUNTRY;
        otherSouece.eName = nil;
        [_sourceArray addObject:otherSouece];
        [self addSourceFormArray:[[response JSONValue] objectForKey:@"countries"]];
    } failure:^(NSString *error) {
        [_tableView didFinishedLoadingTableViewData];
    }];
}
- (void)getMoreFromNetWork
{
    if (_sourceArray.count % 20) {
        [_tableView didFinishedLoadingTableViewData];
        return;
    }
    [RequestManager getCountryListWithstart:_sourceArray.count count:20 token:nil success:^(NSString *response) {
        [self addSourceFormArray:[[response JSONValue] objectForKey:@"countries"]];
    } failure:^(NSString *error) {
        [_tableView didFinishedLoadingTableViewData];
    }];
}
- (void)addSourceFormArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        NSDictionary * dic = [array objectAtIndex:i];
        CountryListCellDataSource * source = [[CountryListCellDataSource alloc] init];
        source.eName = [dic objectForKey:@"en_name"];
        source.cName = [dic objectForKey:@"name"];
        source.identify = [[dic objectForKey:@"id"] intValue];
        [_sourceArray addObject:source];
    }
    [_tableView reloadData];
    [_tableView didFinishedLoadingTableViewData];
}
#pragma mark SerachDelegate
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    DLog();
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setNeedsLayout];
}
- (void)searchDataWithString:(NSString *)searchString
{
    [_searchSourceArray removeAllObjects];
    for (CountryListCellDataSource * source in _sourceArray) {
        NSString * string = [NSString stringWithFormat:@"%@%@",source.cName,source.eName];
        if ([string rangeOfString:_searchBar.text].length != 0) {
            [_searchSourceArray addObject:source];
        }
    }
}
- (void)fixTableViewFrame:(UITableView *)tableView
{
    //防止searchDisControler调整tableview 宽度为320
    CGRect rect = tableView.frame;
    rect.origin.x = 44;
    rect.size.width = 276;
    tableView.frame = rect;
}

#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != _tableView){
        tableView.backgroundColor = _tableView.backgroundColor;
        tableView.separatorColor = _tableView.separatorColor;
        [self searchDataWithString:_searchBar.text];
        [self fixTableViewFrame:tableView];
        return _searchSourceArray.count;
    }
    return _sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify  = @"CELL";
    static NSString * allCell = @"ALLCELL";
    CountryListCellDataSource * source = nil;
    if (_tableView != tableView)
        source = [_searchSourceArray objectAtIndex:indexPath.row];
    else
        source = [_sourceArray objectAtIndex:indexPath.row];
    if ([source.cName isEqualToString:ALLCOUNTRY] || [source.cName isEqualToString:OTHERCOUNTRY]) {
        CountryListCell * cell = [tableView dequeueReusableCellWithIdentifier:allCell];
        if (!cell) {
            cell = [[CountryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            [cell.arrow setHidden:YES];
        }
        cell.dataSource = source;
        return cell;
    }
    CountryListCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CountryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.dataSource = source;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
}

#pragma mark Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if (indexPath.row == 0) {
            [self leftMenuController].viewDeckController.centerController = [[SearchPlazaViewController alloc] init];
            [[self leftMenuController].viewDeckController closeRightViewAnimated:YES];
            [self.navigationController popViewControllerAnimated:NO];

        }else{
            CountryListCellDataSource * source = [_sourceArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:[[CityViewController alloc] initWithCountryId:source.identify CountryName:source.cName] animated:YES];
        }
    }else{
        CountryListCellDataSource * source = [_searchSourceArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:[[CityViewController alloc] initWithCountryId:source.identify CountryName:source.cName] animated:YES];
    }
}
- (void)tapGesture:(UIGestureRecognizer *)gesture
{
    DLog(@"Others");
}
@end
