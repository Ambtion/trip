//
//  CityViewController.m
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "CityViewController.h"
#import "CountryListCell.h"
#import "SearchPlazaViewController.h"

#define ALLCOUNTRY          @"全部"
#define OTHERCOUNTRY        @"其他国家/地区"

@interface CityViewController()
{
   BOOL _isAllState;
    CountryListCellDataSource * _allSource;
}
@property(nonatomic,strong)NSMutableArray * sourceArray;

@end
@implementation CityViewController
@synthesize sourceArray = _sourceArray;

- (id)initWithCountryId:(int)countryId CountryName:(NSString *)countryName eName:(NSString *)ename
{
    if (self = [super init]) {
        _countryId = countryId;
        _countryName = countryName;
        _eName = ename;
        _isAllState = NO;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _tableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(44, 0, 276, self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self getViewWithCName:_countryName eName:_eName];
    _tableView.tableFooterView = nil;
    [self.view addSubview:_tableView];
    [self addBackButton];
    [self initDataContainer];
    [self refrehsFromNetWork];
}
- (UIView *)getViewWithCName:(NSString *)cname eName:(NSString *)ename
{
    CountryListCellDataSource * otherSouece = [[CountryListCellDataSource alloc] init];
    otherSouece.cName = cname;
    otherSouece.eName = ename;
    CountryListCell * other = [[CountryListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [other setoffset:65.f];
    other.dataSource = otherSouece;
    UIView * view = [other getBgView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonClick:)];
    [view addGestureRecognizer:gesture];
    return view;
}
- (void)addBackButton
{
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 5, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"right_county_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}
- (void)initDataContainer
{
    _sourceArray = [NSMutableArray arrayWithCapacity:0];
    _allSource = [[CountryListCellDataSource alloc] init];
    _allSource.cName = @"全部";
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
    if (_isAllState) {
        [RequestManager getAllCityListFromCounty:_countryId start:0 count:200 token:nil success:^(NSString *response) {
            [_sourceArray removeAllObjects];
            [self addSourceFormArray:[[response JSONValue] objectForKey:@"cities"]];
        } failure:^(NSString *error) {
            [_tableView didFinishedLoadingTableViewData];
        }];
    }else{
        [RequestManager getCityListFromCounty:_countryId start:0 count:200 token:nil success:^(NSString *response) {
            [_sourceArray removeAllObjects];
            [self addSourceFormArray:[[response JSONValue] objectForKey:@"cities"]];
        } failure:^(NSString *error) {
            [_tableView didFinishedLoadingTableViewData];
        }];
    }
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
#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sourceArray.count ? _sourceArray.count + 1 : 0;
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
        [cell.arrow setHidden:YES];
        [cell setoffset:65.f];
    }
    if (indexPath.row == 0) {
        cell.dataSource = _allSource;
    }else{
        cell.dataSource = [_sourceArray objectAtIndex:indexPath.row - 1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
}

#pragma mark Action
- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        CountryListCellDataSource * source = [_sourceArray objectAtIndex:indexPath.row - 1];
        SearchPlazaViewController * search = [[SearchPlazaViewController alloc] initWithCountryId:_countryId cityId:source.identify country:@"" city:source.cName];
        search.isOthersSource = [source.cName isEqualToString:@"其他"];
        [self leftMenuController].viewDeckController.centerController = search;
        [[self leftMenuController].viewDeckController closeRightViewAnimated:YES];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        _isAllState = YES;
        [self refrehsFromNetWork];
    }
    
}
- (void)tapGesture:(UIGestureRecognizer *)gesture
{
    
}
@end
