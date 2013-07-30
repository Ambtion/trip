//
//  SearchPlazaViewController.m
//  AhaTrip
//
//  Created by Qu on 13-7-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "SearchPlazaViewController.h"
#import "CQSegmentControl.h"

@class SearchPlazaViewController;
@implementation SearchPlazaViewController

- (id)initWithCountryId:(int)AcountyId cityId:(int)AcityId title:(NSString *)Atitle
{
    self = [super init];
    if (self) {
        _Atitle = Atitle;
        _cateroy = KCateroyAll;
        _countryId = AcountyId;
        _cityId = AcityId;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_menuView setStringTitleArray:[NSArray arrayWithObjects:_Atitle,nil] curString:_Atitle];
}

#pragma mark - ReloadData
- (void)refresFromeNetWork
{
    [self waitForMomentsWithTitle:@"加载中" withView:self.view];
    [RequestManager getPlazaWithCountryId:_countryId cityId:_cityId cateroy:_cateroy start:0 count:20 token:nil success:^(NSString *response) {
        [self.assetsArray removeAllObjects];
        DLog(@"%@",[response JSONValue]);
        [self.assetsArray  addObjectsFromArray:[[[response JSONValue] objectForKey:@"city"] objectForKey:@"findings"]];
        [self convertAssetsToDataSouce];
        [self stopWaitProgressView:nil];

    } failure:^(NSString *error) {
        [self stopWaitProgressView:nil];
        [_tableView didFinishedLoadingTableViewData];
        DLog(@"%@",error);

    }];
}

- (void)getMoreFromeNetWork
{
    [self waitForMomentsWithTitle:@"加载中" withView:self.view];
    [RequestManager getPlazaWithCountryId:_countryId cityId:_cityId cateroy:_cateroy start:0 count:20 token:nil success:^(NSString *response) {
        DLog(@"%@",[response JSONValue]);
        [self.assetsArray   addObjectsFromArray:[[[response JSONValue] objectForKey:@"city"] objectForKey:@"findings"]];
        [self convertAssetsToDataSouce];
        [self stopWaitProgressView:nil];
        
    } failure:^(NSString *error) {
        [self stopWaitProgressView:nil];
        [_tableView didFinishedLoadingTableViewData];
        DLog(@"%@",error);
    }];

}
#pragma mark Add Seg
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_segControllView) {
        NSArray * items = [NSArray arrayWithObjects:@"手",@"网",@"网",@"网", @"网",@"网",@"网",nil];
        CQSegmentControl *  _segControll = [[CQSegmentControl alloc] initWithItemsAndStype:items stype:TitleAndImageSegmented];
        [_segControll addTarget:self action:@selector(segMentChnageValue:) forControlEvents:UIControlEventValueChanged];
        _segControll.frame = CGRectMake(-2, 0, 324, 49);
        DLog(@"LLLLLL%d", _cateroy == KCateroyAll ? 0 : _cateroy + 1);
        _segControll.selectedSegmentIndex = _cateroy == KCateroyAll ? 0 : _cateroy + 1;
        _segControllView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 41.f)];
        [_segControllView addSubview:_segControll];
    }
    return _segControllView;
}

#pragma mark - AweSomeMenuDelegate
- (void)segMentChnageValue:(CQSegmentControl*)seg
{
    if (seg.selectedSegmentIndex == 0) {
        if (_cateroy != KCateroyAll) {
            _cateroy = KCateroyAll;
            [self refresFromeNetWork];
        }
    }else{
        if (seg.selectedSegmentIndex != _cateroy + 1) {
            _cateroy = seg.selectedSegmentIndex - 1;
            [self refresFromeNetWork];
        }
    }
}
- (void)PlazeCell:(PlazeCell *)photoCell clickCoverGroup:(NSDictionary *)info
{
    [self.navigationController pushViewController:[[PhotoDetailController alloc] initWithTitleId:[NSString stringWithFormat:@"%@",[info objectForKey:@"id"]]] animated:YES];
}
@end
