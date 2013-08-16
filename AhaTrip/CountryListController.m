//
//  SouSuoViewController.m
//  Trip
//
//  Created by xuwenjuan on 13-6-13.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "CountryListController.h"
#import "Constants.h"
#import "RequestManager.h"


@implementation CountryListController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = mRGBColor(236, 235, 235);
    //    topbar
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor = mRGBColor(50, 200, 160);
    [self.view addSubview:navView];

    
    countryArray = [NSMutableArray array];

    height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    countryTable  =[[UITableView alloc] initWithFrame:CGRectMake(10, 54, 302, height-54 - 44 - 20) style:UITableViewStylePlain];
    countryTable.dataSource=self;
    countryTable.delegate=self;
    countryTable.backgroundColor=[UIColor clearColor];
    countryTable.separatorColor=[UIColor clearColor];
    [self.view addSubview:countryTable];
    
    //    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0,height-55,320, 55)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    
    //    返回menu页的按钮
    UIButton * closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(15, height - 40, 33, 33)];
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
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 30)];
    Accombodation.text=@"添加国家/地区";
    Accombodation.backgroundColor=[UIColor clearColor];
    Accombodation.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    Accombodation.textColor=[UIColor whiteColor];
    [navView addSubview:Accombodation];
    
    //    request
    [self addCountryRequest];
}
- (void)closeBtnBackMenu:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
//返回到分类列表页
-(void)closeBtnBackMenu
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma request
-(void)addCountryRequest
{
    [RequestManager getCountryAllListForSeletedWithstart:0 count:10000  success:^(NSString *response) {
        NSDictionary *data = [response JSONValue];
        countryArray =[data objectForKey:@"countries"];
        [countryTable reloadData];
    } failure:^(NSString *error) {
        
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  countryArray.count;
    
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
        img.hidden = [countryArray count] - 1 != indexPath.row;

    }
    
    NSDictionary*cityDict=[countryArray objectAtIndex:indexPath.row];
    DetailTextView * dtView = (DetailTextView*)[cell viewWithTag:2000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[cityDict objectForKey:@"name"],[cityDict objectForKey:@"en_name"]];
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[cityDict objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * cityIdDict= [countryArray objectAtIndex:indexPath.row];
    if ([delegate respondsToSelector:@selector(countryListControllerSeletedCountry:)])
        [delegate countryListControllerSeletedCountry:cityIdDict];
}
@end
