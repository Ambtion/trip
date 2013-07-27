//
//  CityViewController.m
//  AhaTrip
//
//  Created by sohu on 13-6-24.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "CityViewController.h"
#import "CountryListCell.h"

@interface CityViewController()
@property(nonatomic,strong)NSMutableArray * sourceArray;
@end
@implementation CityViewController
@synthesize sourceArray = _sourceArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    _tableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(44, 0, 276, self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self addBackButton];
    [self initDataContainer];
    [self refrehsFromNetWork];
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
    allsource.cName = @"中国";
    allsource.eName = nil;
    [_sourceArray addObject:allsource];
    
    for (int i = 0; i < 20; i++) {
        CountryListCellDataSource * source = [[CountryListCellDataSource alloc] init];
        source.eName = @"china";
        source.cName = @"北京";
        [_sourceArray addObject:source];
    }
    CountryListCellDataSource * otherSouece = [[CountryListCellDataSource alloc] init];
    otherSouece.cName = @"其他国家/地区";
    otherSouece.eName = nil;
    [_sourceArray addObject:otherSouece];
    [_tableView reloadData];
    [_tableView didFinishedLoadingTableViewData];
}
#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        [cell.arrow setHidden:YES];
        [cell setoffset:65.f];
    }
    cell.dataSource = [_sourceArray objectAtIndex:indexPath.row];
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
    
}
@end
