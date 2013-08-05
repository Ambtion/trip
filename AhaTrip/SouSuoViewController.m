//
//  SouSuoViewController.m
//  Trip
//
//  Created by xuwenjuan on 13-6-13.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "SouSuoViewController.h"
#import "CityTwoViewController.h"
#import "SingleMenuViewController.h"
#import "AppDelegate.h"
#import "ASIRequest.h"
#import "Constants.h"
#import "PlazeViewController.h"
@interface SouSuoViewController ()

@end

@implementation SouSuoViewController
@synthesize selectCAtegary;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=mRGBColor(236, 235, 235);
    //    topbar
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];
    
    //    request
    [self addCountryRequest];
    
    cityArr = [NSMutableArray array];

    height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    cityTable =[[UITableView alloc] initWithFrame:CGRectMake(10, 54, 302, height-54 - 44 - 20) style:UITableViewStylePlain];
    cityTable.dataSource=self;
    cityTable.delegate=self;
    cityTable.backgroundColor=[UIColor clearColor];
    cityTable.separatorColor=[UIColor clearColor];
    [self.view addSubview:cityTable];
    
    //    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0,height-55,320, 55)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(15, height - 40, 33, 33)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    //    closeMenuBtn.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 30)];
    Accombodation.text=@"添加国家/地区";
    Accombodation.backgroundColor=[UIColor clearColor];
    Accombodation.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    Accombodation.textColor=[UIColor whiteColor];
    [navView addSubview:Accombodation];
}

//返回到分类列表页
-(void)closeBtnBackMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma request
-(void)addCountryRequest
{
    NSString*countryStr=@"http://yyz.ahatrip.info/api/countryList?token=tRyW4rLBiJHffQ";
    [[ASIRequest shareInstance] get:countryStr header:nil delegate:self tag:1000 useCache:YES];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 1000 && request.responseStatusCode == 200)
    {
        NSDictionary *data =[request responseString].objectFromJSONString;
        cityArr=[data objectForKey:@"countries"];
        [cityTable reloadData];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  cityArr.count;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *topicCell = @"TopicCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCell];
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = mRGBColor(50, 200, 160);
        DetailTextView * dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 12, 200, 40)];
        dtView.backgroundColor = [UIColor clearColor];
        dtView.tag = 2000;
        [cell addSubview:dtView];
        
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
        cell.backgroundView=bgView;
        [cell sendSubviewToBack:bgView];
        
        UIImageView * img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
        img.image=[UIImage imageNamed:@"line.png"];
        [cell addSubview:img];
        img.hidden = [cityArr count] - 1 != indexPath.row;

    }
    
    NSDictionary*cityDict=[cityArr objectAtIndex:indexPath.row];
    DetailTextView * dtView = (DetailTextView*)[cell viewWithTag:2000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[cityDict objectForKey:@"name"],[cityDict objectForKey:@"en_name"]];
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[cityDict objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary*cityIdDict=[cityArr objectAtIndex:indexPath.row];
    NSString*cityid=[cityIdDict objectForKey:@"id"];
    NSString*cityStr=[cityIdDict objectForKey:@"name"];
    NSString*cityStr1=[cityIdDict objectForKey:@"en_name"];
    
    CityTwoViewController*city=[[CityTwoViewController alloc] init];
    city.singleCityId=cityid;
    city.singleCityName=cityStr;
    city.singleCityName1=cityStr1;
    city.cateryStr=self.selectCAtegary;
    [self presentViewController:city animated:YES completion:nil];
    
}
@end
