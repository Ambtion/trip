//
//  RightSerachController.m
//  AhaTrip
//
//  Created by Qu on 13-6-23.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "RightSerachController.h"

@implementation RightSerachController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(44, 0, 276, self.view.frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self addSearchView];
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
    _searchDisPlay.delegate = self;
    _searchDisPlay.searchResultsDataSource = self;
    DLog(@"%@",_searchBar.subviews);
}

#pragma mark SerachDelegate
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    DLog();
    [self.navigationController.navigationBar setHidden:YES];
    [self.view setNeedsLayout];
}
#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] init];
}
@end
