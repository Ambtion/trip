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

@interface PlazeViewController ()
@property(nonatomic,strong)NSMutableArray * assetsArray;
@end

@implementation PlazeViewController
@synthesize assetsArray = _assetsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addTableView];
    [self addPathButton];
    [self addCusNavBar];
    [self showLoginViewWithMethodNav:YES withAnimation:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckDelegatePanning;
    self.viewDeckController.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    self.viewDeckController.delegate = nil;
}
- (void)addCusNavBar
{
    _menuView = [[AHMenuNavBarView alloc] initWithView:self.view];
    _menuView.delegate = self;
    [_menuView setStringTitleArray:[NSArray arrayWithObjects:@"最新",@"最热", nil] curString:@"最新"];
}
- (void)addTableView
{
    _tableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.pDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _assetsArray = [[NSMutableArray alloc] initWithCapacity:0];
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
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"icon-drink.png"]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"icon_hotel.png"]
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray * items = [NSArray arrayWithObjects:@"手",@"网",@"网", @"网",@"网",@"网",nil];
    CQSegmentControl *  segControll = [[CQSegmentControl alloc] initWithItemsAndStype:items stype:TitleAndImageSegmented];
    [segControll addTarget:self action:@selector(segMentChnageValue:) forControlEvents:UIControlEventValueChanged];
    segControll.frame = CGRectMake(-2, 0, 324, 49);
    segControll.selectedSegmentIndex = 0;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 41.f)];
    [view addSubview:segControll];
    return view;
}

- (void)segMentChnageValue:(CQSegmentControl*)seg
{
//    if (!seg.selectedSegmentIndex)
//            return;
//    [_tableView refrehOnce];
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
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    
}
- (void)PlazeCell:(PlazeCell *)photoCell clickCoverGroup:(NSDictionary *)info
{
    [self.navigationController pushViewController:[[PhotoDetailController alloc] init] animated:YES];
}
#pragma mark - NavBarDelegate
- (void)menuButtonClick:(UIButton *)button
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}
- (void)searchButtonClick:(UIButton *)button
{
    [self.viewDeckController toggleRightViewAnimated:YES];
}
- (void)titleMenuClickWithInfo:(id)info
{
    
}
- (BOOL)viewDeckController:(IIViewDeckController *)viewDeckController shouldPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    if (ABS(velocity.x) >= ABS(velocity.y))
        return YES;
    else{
        if (velocity.y > 0)
            [self showBar];
        else
            [self hideBar];
    }
    return NO;
}
@end
