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
    self.view.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
    _tableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(44, 0, 276, self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
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
    DLog(@"%@",_searchBar.subviews);
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
    [self performSelector:@selector(addSourceFormArray:) withObject:nil afterDelay:0.f];
}
- (void)addSourceFormArray:(NSArray *)array
{
    [_sourceArray removeAllObjects];
    CountryListCellDataSource * allsource = [[CountryListCellDataSource alloc] init];
    allsource.cName = @"全部";
    allsource.eName = nil;
    [_sourceArray addObject:allsource];
    for (int i = 0; i < 20; i++) {
        CountryListCellDataSource * source = [[CountryListCellDataSource alloc] init];
        source.eName = @"china";
        source.cName = @"中国";
        [_sourceArray addObject:source];
    }
    CountryListCellDataSource * otherSouece = [[CountryListCellDataSource alloc] init];
    otherSouece.cName = @"其他国家/地区";
    otherSouece.eName = nil;
    [_sourceArray addObject:otherSouece];
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
    DLog();
    if (tableView != _tableView){
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
    CountryListCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[CountryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    [cell.arrow setHidden:indexPath.row != 0];
    if (_tableView != tableView)
        cell.dataSource = [_searchSourceArray objectAtIndex:indexPath.row];
    else
        cell.dataSource = [_sourceArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[CityViewController alloc] init] animated:YES];
}
@end
