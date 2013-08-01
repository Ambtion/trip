//
//  SearchPlazaViewController.m
//  AhaTrip
//
//  Created by Qu on 13-7-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "SearchPlazaViewController.h"
#import "CQSegmentControl.h"

@implementation SearchPlazaViewController

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSArray * items = [NSArray arrayWithObjects:@"手",@"网",@"网",@"网", @"网",@"网",@"网",nil];
    CQSegmentControl *  segControll = [[CQSegmentControl alloc] initWithItemsAndStype:items stype:TitleAndImageSegmented];
    [segControll addTarget:self action:@selector(segMentChnageValue:) forControlEvents:UIControlEventValueChanged];
    segControll.frame = CGRectMake(-2, 0, 324, 49);
    segControll.selectedSegmentIndex = 0;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 41.f)];
    [view addSubview:segControll];
    return view;
}

#pragma mark - AweSomeMenuDelegate
- (void)segMentChnageValue:(CQSegmentControl*)seg
{
    //    if (!seg.selectedSegmentIndex)
    //            return;
    //    [_tableView refrehOnce];
}

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
}
- (void)PlazeCell:(PlazeCell *)photoCell clickCoverGroup:(NSDictionary *)info
{
    [self.navigationController pushViewController:[[PhotoDetailController alloc] init] animated:YES];
}
@end
