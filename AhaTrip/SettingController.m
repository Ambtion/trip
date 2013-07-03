//
//  SettingController.m
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "SettingController.h"

static NSString * secTitle[3] = {@"账户",@"分享到",@"其他"};

@implementation SettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235.f/255 green:235.f/255 blue:235.f/255 alpha:1.f];
    [self addNavBar];
    [self addTableView];
}
- (void)addNavBar
{
    UIImageView * bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_bar.png"]];
    [bar setUserInteractionEnabled:YES];
    bar.frame = CGRectMake(0, 0, 320, 44);
    [self.view addSubview:bar];
    UIButton * done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(320 - 77, 7, 70, 30);
    [done setImage:[UIImage imageNamed:@"setting_bar_done.png"] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:done];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",indexPath];
    return cell;
}

#pragma mark Action
- (void)doneButtonClick:(UIButton *)button
{
    
}
@end
