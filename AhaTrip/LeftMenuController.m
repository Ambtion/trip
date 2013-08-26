//
//  LeftViewController.m
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "LeftMenuController.h"
#import "LeftMenuCell.h"
#import "UIImageView+WebCache.h"

static  NSString *   menuText[4] =   {@"精选",@"个人昵称",@"消息",@"设置"};
static  NSString *   image[4]    =   {@"left_Icon_home.png",@"avatar.png",@"left_Icon_mes.png",@"left_Icon_setting.png"};

@implementation LeftMenuController
@synthesize plazeController = _plazeController,homeController = _homeController,
ntfController = _ntfController,setController = _setController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //bgView
    self.view.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
    _selectPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReciveNotification:) name:@"DidReceiveRemoteNotification" object:nil];
}
- (void)applicationDidReciveNotification:(id)sender
{
    [_tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [RequestManager getUserInfoWithUserId:[LoginStateManager currentUserId]  success:^(NSString *response) {
        _userInfo = [[response JSONValue] objectForKey:@"user"];
        [_tableView reloadData];
        [_tableView selectRowAtIndexPath:_selectPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } failure:^(NSString *error) {
        _userInfo = nil;
        [_tableView selectRowAtIndexPath:_selectPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }];
}
#pragma mark - dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"CELL";
    LeftMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    if (indexPath.row == 1 && _userInfo) {
        DLog(@"%@",_userInfo);
        cell.titleLabel.text = [_userInfo objectForKey:@"username"];
        [cell.iconImage.imageView setImageWithURL:[NSURL URLWithString:[_userInfo objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:image[indexPath.row]]];
    }else{
        cell.iconImage.imageView.image = [UIImage imageNamed:image[indexPath.row]];
        cell.titleLabel.text = menuText[indexPath.row];
    }
    [cell.countLabel setHidden:indexPath.row != 2 || [[UIApplication sharedApplication] applicationIconBadgeNumber] <= 0];
    cell.countLabel.text = [NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] applicationIconBadgeNumber]];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        [self changeCenterControllerWith:indexPath];
    }];
}

- (void)changeCenterControllerWith:(NSIndexPath*)indexPath
{
    _selectPath = indexPath;
    UIViewController * controller = nil;
    switch (indexPath.row) {
    case 0:
        controller = self.plazeController;
        break;
    case 1:
        controller = self.homeController;
        break;
    case 2:
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        controller = self.ntfController;
        break;
    case 3:
        [self.setController getUserInfo];
        controller = self.setController;
        break;
    default:
        break;
    }
    self.viewDeckController.centerController = controller;
}

#pragma mark
- (PlazeViewController *)plazeController
{
    if (!_plazeController)
        _plazeController = [[PlazeViewController alloc] init];
    return _plazeController;
}
- (HomePageController *)homeController
{
    if (!_homeController)
        _homeController = [[HomePageController alloc] initAsRootViewController:YES withUserId:[LoginStateManager currentUserId]];
    return _homeController;
}
- (NotificationController *)ntfController
{
    if (!_ntfController)
        _ntfController = [[NotificationController alloc] init];
    return _ntfController;
}
- (SettingController*)setController
{
    if (!_setController)
        _setController = [[SettingController alloc] init];
    return _setController;
}
@end
