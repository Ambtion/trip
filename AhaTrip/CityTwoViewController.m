//
//  CityTwoViewController.m
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "CityTwoViewController.h"
//#import "CenterViewController.h"
#import "Constants.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"
//#import "UIViewController+JASidePanel.h"
#import "PlazeViewController.h"
@interface CityTwoViewController ()

@end

@implementation CityTwoViewController
@synthesize singleCityId;
@synthesize  cateryStr;
@synthesize singleCityName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=mRGBColor(236, 235, 235);
    

    
//    request data
    singleCityArr = [NSMutableArray array];
    NSLog(@"%d",singleCityArr.count);

    [self addRequestSingleCity];
    singlecityTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 44+10, self.view.frame.size.width-20, self.view.frame.size.height-100) style:UITableViewStylePlain];
    singlecityTable.dataSource=self;
    singlecityTable.delegate=self;
    [self.view addSubview:singlecityTable];
    
       
    //    topbar
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];

    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 30)];
    Accombodation.text=singleCityName;
    Accombodation.backgroundColor=[UIColor clearColor];
    Accombodation.textColor=[UIColor whiteColor];
    Accombodation.font=[UIFont systemFontOfSize:18];
    [navView addSubview:Accombodation];

    //    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44,320, 44)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10, self.view.frame.size.height-44, 50, 44)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];

    // Do any additional setup after loading the view from its nib.
}

//返回到国家分类列表页
-(void)closeBtnBackMenu{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma request
-(void)addRequestSingleCity{
    NSString*singleCityStr=@"http://yyz.ahatrip.info/city/list";
   
    NSString*str=[NSString stringWithFormat:@"%@?country_id=%@",singleCityStr,singleCityId];
     NSLog(@"%@",str);
    
    [[ASIRequest shareInstance] get:str header:nil delegate:self tag:5000 useCache:YES];



}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 5000 && request.responseStatusCode == 200)
    {
        NSDictionary *data =[request responseString].objectFromJSONString;
        singleCityArr=[data objectForKey:@"cities"];
        [singlecityTable reloadData];
        
        
        
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  singleCityArr.count;
//    return 100;
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
        UILabel*citylabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        citylabel.backgroundColor=[UIColor clearColor];
        
        citylabel.tag=1000;
        [cell addSubview:citylabel];
        
        
        
    }
    UILabel*cityLabel=(UILabel*)[cell viewWithTag:1000];
    NSDictionary*cityDict=[singleCityArr objectAtIndex:indexPath.row];
    cityLabel.text=[cityDict objectForKey:@"name"];
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//      DDMenuController *menuController = (DDMenuController*)((AppDelegate *)[[UIApplication sharedApplication] delegate]).menuController;
    
//    CenterViewController*city=[[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
//    NSDictionary*dict=[singleCityArr objectAtIndex:indexPath.row];
//    NSString*str=[dict objectForKey:@"name"];
//    
//    
//  city.countryName=str;
//
//    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:city];
//
    PhotoViewController*photoCTL=[[PhotoViewController alloc] init];
    photoCTL.singleCityName=self.singleCityName;
    photoCTL.singleCityId=self.singleCityId;
    photoCTL.cateryStr=self.cateryStr;
    [self presentViewController:photoCTL animated:YES completion:nil];
    
}

@end
