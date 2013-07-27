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
#import "SingleMenuViewController.h"
#import "PlazeViewController.h"
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
    [self addEveryCategary];
}
//每一个分类
-(void)addEveryCategary{
    
    //    0：景观  1：购物  2：餐饮 3：住宿  4：咖啡 5：娱乐  6：其他
    NSString*viewStr=@"景观";
    NSString*shopStr=@"购物";
    NSString*foodStr=@"美食";
    NSString*cafeiStr=@"住宿";
    NSString*departMentStr=@"咖啡";
    NSString*entertainment=@"娱乐";
    
    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:viewStr,@"menu",nil];
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:shopStr,@"menu",nil];
    
    NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:foodStr,@"menu",nil];
    
    NSDictionary *dic4=[NSDictionary dictionaryWithObjectsAndKeys:cafeiStr,@"menu",nil];
    
    NSDictionary *dic5=[NSDictionary dictionaryWithObjectsAndKeys:departMentStr,@"menu",nil];
    NSDictionary *dic6=[NSDictionary dictionaryWithObjectsAndKeys:entertainment,@"menu",nil];
    
    menuArr=[NSMutableArray arrayWithObjects:dic1,dic2,dic3,dic4,dic5,dic6,nil];
    


}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckDelegatePanning;
    self.viewDeckController.delegate = self;
//    if (![LoginStateManager isLogin])
//        [self showLoginViewWithMethodNav:NO withAnimation:YES];
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
        _rightSearch = [[UINavigationController alloc] initWithRootViewController:[[RightSerachController alloc] init]];
        _rightSearch.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [_rightSearch.navigationBar setHidden:YES];
    }
    if (isNil)
        self.viewDeckController.rightController = nil;
    else
        self.viewDeckController.rightController = _rightSearch;
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
                                                               ContentImage:[UIImage imageNamed:@"icon_drink.png"]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"icon_Entertainment.png"]
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:[UIImage imageNamed:@"icon_hotel.png"]
                                                    highlightedContentImage:nil];
    
    NSArray * menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5,starMenuItem6,nil];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"CELL";
    PlazeCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[PlazeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        cell.delegate = self;
//        [cell setCellShowEnable:NO];
    }
    cell.dataSource = [_assetsArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - AweSomeMenuDelegate
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    
    NSLog(@"Select the index : %d",idx);
    NSDictionary*menuDict=[menuArr objectAtIndex:idx];
    NSString*menuSelectStr=[menuDict objectForKey:@"menu"];
    
    SingleMenuViewController*singleMenu=[[SingleMenuViewController alloc] init];
    singleMenu.menuStr=menuSelectStr;
    singleMenu.selectID=idx+1;
    NSLog(@"%@%d",singleMenu.menuStr,singleMenu.selectID);
    [self presentViewController:singleMenu animated:YES completion:nil];

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
    DLog(@"");
    [self setRightSearchBarTonil:YES];
}
@end
