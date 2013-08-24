//
//  CityTwoViewController.m
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "CityListController.h"
#import "Constants.h"
#import "SeletedPhotoMethodController.h"
#import "RequestManager.h"

@implementation CityListController
@synthesize countryInfo;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = mRGBColor(236, 235, 235);
    DLog(@"%@",self.countryInfo);
    //    request data
    singleCityArr = [NSMutableArray array];
    height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    [self addRequestSingleCity];
    singlecityTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 44+10,302, height-100) style:UITableViewStylePlain];
    singlecityTable.dataSource=self;
    singlecityTable.delegate=self;
    singlecityTable.backgroundColor=[UIColor clearColor];
    singlecityTable.separatorColor=[UIColor clearColor];
    [self.view addSubview:singlecityTable];
    
    //    topbar
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];
    
    DetailTextView * dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 7, 250, 40)];
    dtView.backgroundColor = [UIColor clearColor];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[self.countryInfo objectForKey:@"name"],[self.countryInfo objectForKey:@"en_name"]];
    [dtView setText:str WithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20] AndColor:[UIColor whiteColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[self.countryInfo objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:16.f] AndColor:[UIColor whiteColor]];
    [navView addSubview:dtView];
    
    //    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, height-55,320, 55)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10,height-44, 33, 33)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
    //  返回主页的按钮
    UIButton*closeAll=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeAll setFrame:CGRectMake(320 - 55, height - 55, 55, 55)];
    closeAll.contentMode = UIViewContentModeCenter;
    [closeAll setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
    [closeAll addTarget:self action:@selector(closeBtnBackMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeAll];
    
}
- (void)closeBtnBackMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
//返回到国家分类列表页
-(void)closeBtnBackMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma request
-(void)addRequestSingleCity
{
    [RequestManager getCityListFromCounty:[[self.countryInfo objectForKey:@"id"] integerValue] start:0 count:10000 token:nil success:^(NSString *response) {
        NSDictionary *data =[response JSONValue];
        singleCityArr=[data objectForKey:@"cities"];
        [singlecityTable reloadData];
        
    } failure:^(NSString *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  singleCityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *topicCell = @"TopicCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:topicCell];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = mRGBColor(50, 200, 160);
        DetailTextView * dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 12, 200, 40)];
        dtView.backgroundColor = [UIColor clearColor];
        dtView.tag = 5000;
        [cell addSubview:dtView];
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
        cell.backgroundView = bgView;
        UIImageView*img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
        img.image=[UIImage imageNamed:@"line.png"];
        img.tag = 10000;
        [cell addSubview:img];
    }
    
    UIView * view = [cell viewWithTag:10000];
    view.hidden = indexPath.row != singleCityArr.count - 1;
    NSDictionary*cityDict=[singleCityArr objectAtIndex:indexPath.row];
    
    DetailTextView * dtView = (DetailTextView*)[cell viewWithTag:5000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[cityDict objectForKey:@"name"],[cityDict objectForKey:@"en_name"]];
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[cityDict objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([delegate respondsToSelector:@selector(cityListControllerDidSeletedCityInfo:)])
        [delegate cityListControllerDidSeletedCityInfo:[singleCityArr objectAtIndex:indexPath.row]];
}

@end
