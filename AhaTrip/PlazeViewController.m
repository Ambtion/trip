//
//  PlarzeViewController.m
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PlazeViewController.h"
#import "CQSegmentControl.h"
#import "PhotoDetailController.h"
#import "PlazeViewController.h"
#import "RequestManager.h"
#import "UploadViewControllerManager.h"

@implementation PlazeViewController
@synthesize assetsArray = _assetsArray;
@synthesize dataSouceArray = _dataSouceArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTableView];
    [self addPathButton];
    [self addCusNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckDelegatePanning;
    self.viewDeckController.delegate = self;
    if (![LoginStateManager isLogin])
        [self showLoginViewWithMethodNav:NO withAnimation:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewDeckController.panningMode = IIViewDeckPanningViewPanning;
    self.viewDeckController.delegate = nil;
}
- (void)setRightSearchBarTonil:(BOOL)isNil
{
    if (!_rightSearch) {
        _rightSearch = [[RightSerachController alloc] init];
    }
    if (isNil)
        self.viewDeckController.rightController = nil;
    else{
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:_rightSearch];
        nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [nav.navigationBar setHidden:YES];
        self.viewDeckController.rightController = nav;
    }
}
- (void)addCusNavBar
{
    _menuView = [[AHMenuNavBarView alloc] initWithView:self.view];
    _menuView.delegate = self;
    [_menuView setStringTitleArray:[NSArray arrayWithObjects:@"广场",@"最热", nil] curString:@"广场"];
}

- (void)addTableView
{
    
    _tableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = nil;
    [self.view addSubview:_tableView];
    _assetsArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dataSouceArray  = [[NSMutableArray alloc] initWithCapacity:0];
    [self refresFromeNetWork];
}

- (void)addPathButton
{
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"icon_sight.png"]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc]
                                      initWithImage:storyMenuItemImage
                                      highlightedImage:storyMenuItemImagePressed
                                      ContentImage:[UIImage imageNamed:@"icon_shopping.png"]
                                      highlightedContentImage:nil];
    
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"icon_food.png"]
                                                    highlightedContentImage:nil];
//    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
//                                                           highlightedImage:storyMenuItemImagePressed
//                                                               ContentImage:[UIImage imageNamed:@"icon_drink.png"]
//                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"icon_hotel.png"]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"icon_Entertainment.png"]
                                                    highlightedContentImage:nil];
 
    
    NSArray * menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5,nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
                                                highlightedContentImage:nil];
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:startItem optionMenus:menus];
    menu.startPoint = CGPointMake(40, self.view.bounds.size.height - 40);
    menu.delegate = self;
    [self.view addSubview:menu];
}

#pragma BarAction
- (void)showBar
{
    [UIView animateWithDuration:0.3 animations:^{
        [_menuView showMenuBar];
        _tableView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44);
    } completion:^(BOOL finished) {
    }];
}
- (void)hideBar
{
    _tableView.frame = self.view.bounds;
    [UIView animateWithDuration:0.3 animations:^{
        [_menuView hideMenuBar];
    } completion:^(BOOL finished) {
    }];
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
    [self waitForMomentsWithTitle:@"加载中" withView:self.view];
    [RequestManager getPlazaWithstart:0 count:20 success:^(NSString *response) {
        [_assetsArray removeAllObjects];
        [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
        [self convertAssetsToDataSouce];
        [self stopWaitProgressView:nil];
    } failure:^(NSString *error) {
        [self stopWaitProgressView:nil];
        [_tableView didFinishedLoadingTableViewData];
        DLog(@"%@",error);
    }];
}
- (void)convertAssetsToDataSouce
{
    [_dataSouceArray removeAllObjects];
//    DLog(@"%@",[_assetsArray lastObject]);
    for (int i = 0;i < _assetsArray.count ; i+=2) {
        PlazeCellDataSource * source = [[PlazeCellDataSource alloc] init];
        source.leftInfo = [_assetsArray objectAtIndex:i];
        if (i + 1 < _assetsArray.count) {
            source.rightInfo = [_assetsArray objectAtIndex:i+1];
        }
        [_dataSouceArray addObject:source];
    }
    [_tableView reloadData];
    [_tableView didFinishedLoadingTableViewData];
}
- (void)getMoreFromeNetWork
{
    DLog();
    if (_assetsArray.count % 20){
        [_tableView didFinishedLoadingTableViewData];
        return;
    }
    [RequestManager getPlazaWithstart:_assetsArray.count count:20  success:^(NSString *response) {
        [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
        [self convertAssetsToDataSouce];
    } failure:^(NSString *error) {
        [_tableView didFinishedLoadingTableViewData];
    }];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSouceArray.count;
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
    cell.dataSource = [_dataSouceArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - AweSomeMenuDelegate
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [self presentModalViewController:[[UploadViewControllerManager alloc] initWithCateroyId:idx] animated:YES];
}
- (void)PlazeCell:(PlazeCell *)photoCell clickCoverGroup:(NSDictionary *)info
{
    [self.navigationController pushViewController:[[PhotoDetailController alloc] initWithTitleId:[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]]] animated:YES];
}

#pragma mark - NavBarDelegate
- (void)menuButtonClick:(UIButton *)button
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}
- (void)searchButtonClick:(UIButton *)button
{
    [self setRightSearchBarTonil:NO];
    [self.viewDeckController toggleRightViewAnimated:YES];
}
- (void)titleMenuClickWithInfo:(id)info
{
    DLog();
}

- (BOOL)viewDeckController:(IIViewDeckController *)viewDeckController shouldPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    if (ABS(velocity.x) >= ABS(velocity.y)){
        [self setRightSearchBarTonil:NO];
        return YES;
    }
    else{
        if (velocity.y > 0)
            [self showBar];
        else
            [self hideBar];
    }
    return NO;
}
- (void)viewDeckController:(IIViewDeckController *)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    [self setRightSearchBarTonil:YES];
}
@end
