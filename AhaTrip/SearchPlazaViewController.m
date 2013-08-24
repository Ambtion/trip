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
@synthesize isOthersSource;
- (id)initWithCountryId:(int)AcountyId cityId:(int)AcityId  country:(NSString *)country city:(NSString *)city
{
    self = [super init];
    if (self) {
        _cateroy = KCateroyAll;
        _cityId = AcityId;
        _cityName = city;
        _countryId = AcountyId;
        _countryName = country;
        self.isOthersSource = NO;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        _cityId = ALLCITYID;
        _countryId = ALLCITYID;
        _cityName = @"全部";
        _countryName = nil;
        _cateroy = KCateroyAll;
        self.isOthersSource = NO;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_menuView setStringTitleArray:[NSArray arrayWithObjects:_cityName,nil] curString:_cityName];
}

#pragma mark - ReloadData
- (void)refresFromeNetWork
{
    [self waitForMomentsWithTitle:@"加载中" withView:self.view];
    [RequestManager getPlazaWithCountryId:_countryId cityId:_cityId cateroy:_cateroy start:0 count:20 token:nil success:^(NSString *response) {
        [self.assetsArray removeAllObjects];
        NSString * key = _cityId == ALLCITYID ? @"total" : @"city";
        [self.assetsArray  addObjectsFromArray:[[[response JSONValue] objectForKey:key] objectForKey:@"findings"]];
        [self convertAssetsToDataSouce];
        [self stopWaitProgressView:nil];
        
    } failure:^(NSString *error) {
        [self stopWaitProgressView:nil];
        [_tableView didFinishedLoadingTableViewData];        
    }];
}

- (void)getMoreFromeNetWork
{
    if (self.assetsArray.count % 20){
        [_tableView didFinishedLoadingTableViewData];
        return;
    }
    [RequestManager getPlazaWithCountryId:_countryId cityId:_cityId cateroy:_cateroy start:0 count:20 token:nil success:^(NSString *response) {
        NSString * key = _cityId == ALLCITYID  ? @"total" : @"city";
        [self.assetsArray  addObjectsFromArray:[[[response JSONValue] objectForKey:key] objectForKey:@"findings"]];
        [self convertAssetsToDataSouce];
        
    } failure:^(NSString *error) {
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
        NSArray * items = [NSArray arrayWithObjects:@"手",@"网",@"网",@"网",@"网",@"w",nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string = @"CELL";
    PlazeCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[PlazeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        cell.delegate = self;
    }
    [cell setCellShowIconEnable:_cateroy == KCateroyAll || _cityId == ALLCITYID];
    [cell setCellShowCityEnable:_cityId == ALLCITYID || self.isOthersSource];
    cell.dataSource = [self.dataSouceArray objectAtIndex:indexPath.row];
    return cell;
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
