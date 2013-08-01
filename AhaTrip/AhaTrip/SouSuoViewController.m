//
//  SouSuoViewController.m
//  Trip
//
//  Created by xuwenjuan on 13-6-13.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "SouSuoViewController.h"
#import "CenterViewController.h"
#import "CityTwoViewController.h"
#import "SingleMenuViewController.h"
#import "CenterViewController.h"
#import "AppDelegate.h"
#import "ASIRequest.h"
#import "Constants.h"   
@interface SouSuoViewController ()

@end

@implementation SouSuoViewController
@synthesize selectCAtegary;
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
    
    //    topbar
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];

   
//    request
    [self addCountryRequest];
       
   cityArr = [NSMutableArray array];
    NSLog(@"%d",cityArr.count);

    
    
    cityTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 54, self.view.frame.size.width-20, self.view.frame.size.height-54-44) style:UITableViewStylePlain];
    cityTable.dataSource=self;
    cityTable.delegate=self;
    [self.view addSubview:cityTable];
    
    
    
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

    
    //    返回主页的按钮
    UIButton*backZhuye=[UIButton buttonWithType:UIButtonTypeCustom];
    [backZhuye setFrame:CGRectMake(280, self.view.frame.size.height-44, 50, 44)];
    backZhuye.contentMode=UIViewContentModeScaleAspectFit;
    [backZhuye setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
    [backZhuye addTarget:self action:@selector(backZhuyeClcik) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backZhuye];
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 30)];
    Accombodation.text=@"添加国家/地区";
    Accombodation.backgroundColor=[UIColor clearColor];
    Accombodation.textColor=[UIColor whiteColor];
    Accombodation.font=[UIFont systemFontOfSize:18];
    [navView addSubview:Accombodation];

    // Do any additional setup after loading the view from its nib.
}

//返回到分类列表页
-(void)closeBtnBackMenu{

    
    [self dismissViewControllerAnimated:YES completion:nil];

}
//回到主页
-(void)backZhuyeClcik{

    CenterViewController*centerCTL=[[CenterViewController alloc] init];
    [self presentViewController:centerCTL animated:YES completion:nil];

}



#pragma request
-(void)addCountryRequest{
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
    
    
    
    
    //    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
  return  cityArr.count;
//   return 100;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *topicCell = @"TopicCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCell];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = mRGBColor(50, 200, 160);

        UILabel*citylabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, 40)];
        citylabel.tag=1000;
//        citylabel.text=@"women";
        [cell addSubview:citylabel];
        
        UILabel*citylabelEn=[[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 40)];
        citylabelEn.tag=2000;
        //        citylabel.text=@"women";
        [cell addSubview:citylabelEn];
        
        
         }
    UILabel*cityLabel=(UILabel*)[cell viewWithTag:1000];
    NSDictionary*cityDict=[cityArr objectAtIndex:indexPath.row];
    cityLabel.text=[cityDict objectForKey:@"name"];
   
    UILabel*cityLabelEn=(UILabel*)[cell viewWithTag:2000];
   
    cityLabelEn.text=[cityDict objectForKey:@"en_name"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary*cityIdDict=[cityArr objectAtIndex:indexPath.row];
    NSString*cityid=[cityIdDict objectForKey:@"id"];
    NSString*cityStr=[cityIdDict objectForKey:@"name"];
    

    CityTwoViewController*city=[[CityTwoViewController alloc] init];
    city.singleCityId=cityid;
    city.singleCityName=cityStr;
    city.cateryStr=self.selectCAtegary;
    [self presentViewController:city animated:YES completion:nil];

    
}
@end
