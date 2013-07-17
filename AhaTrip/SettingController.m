//
//  SettingController.m
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "SettingController.h"
#import "FeedBackController.h"
#import "PlazeViewController.h"

static NSString * secTitle[3] = {@"账户",@"分享到",@"其他"};
static NSString * titleSection1[2] = {@"新浪微博",@"腾讯微博"};
static NSString * iconSection1[2] = {@"setting_Icon_sina.png",@"setting_Icon_qq.png"};
static NSString * titleSection2[4] = {@"关于我们",@"给AhaTrip打分",@"意见反馈",@"清楚缓冲"};

@implementation SettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235.f/255 green:235.f/255 blue:235.f/255 alpha:1.f];
    [self getUserInfo];
    [self addTableView];
    [self addNavBar];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    self.viewDeckController.delegate = nil;
    self.viewDeckController.rightController = nil;
}
- (void)getUserInfo
{
    acountSource = [[AcountSettingCellDataSource alloc] init];
    acountSource.poraitImage = [UIImage imageNamed:@"test_portrait.png"];
    acountSource.userName = @"曹小盖er";
    acountSource.userDes = @"没什么描述的";
    acountSource.birthday = @"2012-2-23";
    acountSource.isBoy = YES;
}
- (void)addNavBar
{
    UIImageView * bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_bar.png"]];
    [bar setUserInteractionEnabled:YES];
    bar.frame = CGRectMake(0, 0, 320, 48);
    bar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bar];
    UIButton * done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(320 - 77, 7, 70, 30);
    [done setImage:[UIImage imageNamed:@"setting_bar_done.png"] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:done];
    
    UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(7, 7, 30, 30);
    leftbutton.tag = 100;
    [leftbutton setImage:[UIImage imageNamed:@"ItemMenuBarBg.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(leftbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:leftbutton];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view.backgroundColor = [UIColor clearColor];
    UIButton * logoutButton = [[UIButton  alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    [logoutButton setImage:[UIImage imageNamed:@"setting_logout.png"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:logoutButton];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return secTitle[section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 426.f;
            break;
        case 1:
            return 42.f;
            break;
        case 2:
            return 42.f;
            break;
        default:
            break;
    }
    return 0.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 4;
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellId = @"CELL_0";
        AcountSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AcountSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.delegate = self;
        }
        cell.dataSouce = acountSource;
        return cell;
    }
    if (indexPath.section == 1) {
        static NSString * cellId = @"CELL_1";
        BindCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[BindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.delegate = self;
        }
        cell.iconImageView.image = [UIImage imageNamed:iconSection1[indexPath.row]];
        [cell.bindSwitch setOn:indexPath.row % 2];
        cell.nameLabel.text = titleSection1[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        static NSString * cellId = @"CELL_2";
        TitleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[TitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = titleSection2[indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark Action
- (void)leftbuttonClick:(UIButton *)button
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}
- (void)doneButtonClick:(UIButton *)button
{
    DLog();
}
- (void)acountSettingCell:(AcountSettingCell *)cell changeImage:(UIButton *)button
{
    DLog();
}
- (void)acountSettingCellDidBeginEdit:(AcountSettingCell *)cell
{
    CGFloat offsetY = 300;
    if (_tableView.contentOffset.y < offsetY)
        [_tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

- (void)acountSettingCellDidFinishedEdit:(AcountSettingCell *)cell
{
    DLog();
}
- (void)BindCell:(BindCell *)cell SwithChanged:(UISwitch *)bindSwitch
{
    DLog();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: //关于
                
                break;
            case 1: //评分
                break;
            case 2: //反馈
                [self.navigationController pushViewController:[[FeedBackController alloc] init] animated:YES];
                break;
            case 3: //缓冲
                [self showPopAlerViewWithMes:@"确认删除缓存" withDelegate:self cancelButton:@"取消" otherButtonTitles:@"确认",nil];
                break;
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"确认删除缓存"]) {
        if (buttonIndex == 1) {
            [CacheManager removeAllCache];
        }
    }
    if ([[alertView message] isEqualToString:@"确认登出"]) {
        if (buttonIndex == 1) {
            [LoginStateManager logout];
            self.viewDeckController.centerController = [[self leftMenuController] plazeController];
        }
    }
}
#pragma mark logout
- (void)logoutButtonClick:(UIButton *)button
{
    [self showPopAlerViewWithMes:@"确认登出" withDelegate:self cancelButton:@"取消" otherButtonTitles:@"确认",nil];
}

@end
