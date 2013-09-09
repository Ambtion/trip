//
//  HomePageController.m
//  AhaTrip
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "HomePageController.h"
#import "RequestManager.h"
#import "UploadViewControllerManager.h"
#import "FGuideViewManager.h"

@interface HomePageController ()
{
    NSDictionary * tempToDeleteInfo;
}
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
    [self addPathButton];
    if ([self isIphone5]) {
        [FGuideViewManager showFGuideViewWithImageaArray:[NSArray arrayWithObjects:@"03_for5.png", nil] superController:self];
    }else{
        [FGuideViewManager showFGuideViewWithImageaArray:[NSArray arrayWithObjects:@"03.png", nil] superController:self];
    }
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
    
}

- (void)backButtonClick:(UIButton *)button
{
    if (_isRootController)
        [self.viewDeckController toggleLeftViewAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - AweSomeMenuDelegate
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [self presentModalViewController:[[UploadViewControllerManager alloc] initWithCateroyId:idx] animated:YES];
}
#pragma mark TableView
- (void)addTableView
{
    _tableView = [[EGRefreshTableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundColor = [UIColor colorWithRed:235.f/255 green:235.f/255 blue:235.f/255 alpha:1];
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
    [RequestManager getUserInfoWithUserId:_userId  success:^(NSString *response) {
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
        [RequestManager getFindsUserId:_userId Withstart:0 count:20  success:^(NSString *response) {
            [_assetsArray removeAllObjects];
            [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
            [self convertAssetsToDataSouce];
        } failure:^(NSString *error) {
            [_tableView didFinishedLoadingTableViewData];
        }];
    }else{
        [RequestManager getFavUserId:_userId Withstart:0 count:20  success:^(NSString *response) {
            DLog(@"%@",[response JSONValue]);
            [_assetsArray removeAllObjects];
            [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
            [self convertAssetsToDataSouce];
        } failure:^(NSString *error) {
            [_tableView didFinishedLoadingTableViewData];
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
        [RequestManager getFindsUserId:_userId Withstart:_assetsArray.count count:20   success:^(NSString *response) {
            [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
            [self convertAssetsToDataSouce];
        } failure:^(NSString *error) {
            [_tableView didFinishedLoadingTableViewData];
        }];
    }else{
        [RequestManager getFavUserId:_userId Withstart:_assetsArray.count count:20  success:^(NSString *response) {
            [_assetsArray addObjectsFromArray:[[response JSONValue] objectForKey:@"findings"]];
            [self convertAssetsToDataSouce];
        } failure:^(NSString *error) {
            [_tableView didFinishedLoadingTableViewData];
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
- (void)PlazeCell:(PlazeCell *)photoCell longPressGroup:(NSDictionary *)info
{
    if (tempToDeleteInfo || !_isFinds) return;
    if ([self isMineWithOwnerId:_userId]) {
        tempToDeleteInfo = info;
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确认删除图片", nil];
        [sheet showInView:self.view];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"%@",tempToDeleteInfo);
   
    if (buttonIndex == 0) { //删除
        [RequestManager deleteFindsWithId:[[tempToDeleteInfo objectForKey:@"id"] intValue] success:^(NSString *response) {
            if ([[[[response JSONValue] objectForKey:@"result"] objectForKey:@"code"] intValue] == 200) {
                [_assetsArray removeObject:tempToDeleteInfo];
                [self convertAssetsToDataSouce];
            }else{
                [self showTotasViewWithMes:@"删除失败"]; 
            }
            tempToDeleteInfo = nil;
        } failure:^(NSString *error) {
            tempToDeleteInfo = nil;
            [self showTotasViewWithMes:@"删除失败"];
        }];
    }else{
        tempToDeleteInfo = nil;
    }
}
@end
