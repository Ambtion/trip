//
//  LeftViewController.m
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "LeftMenuController.h"
#import "LeftMenuCell.h"

#import "PlarzeViewController.h"

static  NSString *   menuText[4] =   {@"主页",@"个人昵称",@"消息",@"设置"};
static  NSString *   image[4]    =   {@"left_Icon_home.png",@"left_Icon_setting.png",@"left_Icon_mes.png",@"left_Icon_setting.png"};

@implementation LeftMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //bgView
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"LeftMenuGround.png"];
    [self.view addSubview:bgView];
    _selectPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    UIImageView * logoText = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 69, 320, 59)];
//    logoText.image = [UIImage imageNamed:@"logoText.png"];
//    [self.view addSubview:logoText];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds                                                  style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView selectRowAtIndexPath:_selectPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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
        cell.iconImage.imageView.image = [UIImage imageNamed:image[indexPath.row]];
        cell.titleLabel.text = menuText[indexPath.row];
        [cell.countLabel setHidden:indexPath.row != 2];
        
        return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.view.userInteractionEnabled = NO;
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        [self changeCenterControllerWith:indexPath];
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)changeCenterControllerWith:(NSIndexPath*)indexPath
{
    _selectPath = indexPath;
    if (indexPath.row == 0) {
        self.viewDeckController.centerController = [[PlarzeViewController alloc] init];
    }
    if (indexPath.row == 1) {
        self.viewDeckController.centerController = [[PlarzeViewController alloc] init];
    }
    if (indexPath.row == 2) {
        self.viewDeckController.centerController = [[PlarzeViewController alloc] init];
    }
    if (indexPath.row == 3) {
        self.viewDeckController.centerController = [[PlarzeViewController alloc] init];
    }

}
@end
