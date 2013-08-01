//
//  SouSuoViewController.m
//  Trip
//
//  Created by xuwenjuan on 13-6-13.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "SouSuoViewController.h"
//#import "CenterViewController.h"
#import "CityTwoViewController.h"
#import "SingleMenuViewController.h"
//#import "CenterViewController.h"
#import "AppDelegate.h"
#import "ASIRequest.h"
#import "Constants.h"   
#import "PlazeViewController.h"
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

    if ([self isIphone5]) {
        height=548;
    }else{
        
        height=460;
    }

    
    cityTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 54, 302, height-54-44) style:UITableViewStylePlain];
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
    [closeMenuBtn setFrame:CGRectMake(15,height-40, 33, 33)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
//    closeMenuBtn.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];

//    
//    //    返回主页的按钮
//    UIButton*backZhuye=[UIButton buttonWithType:UIButtonTypeCustom];
//    [backZhuye setFrame:CGRectMake(280, self.view.frame.size.height-44, 40, 40)];
//    backZhuye.contentMode=UIViewContentModeScaleAspectFit;
//    [backZhuye setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
//    [backZhuye addTarget:self action:@selector(backZhuyeClcik) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backZhuye];
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 30)];
    Accombodation.text=@"添加国家/地区";
    Accombodation.backgroundColor=[UIColor clearColor];
    Accombodation.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    Accombodation.textColor=[UIColor whiteColor];
//    Accombodation.font=[UIFont systemFontOfSize:18];
    [navView addSubview:Accombodation];

    // Do any additional setup after loading the view from its nib.
}

//返回到分类列表页
-(void)closeBtnBackMenu{

    
    [self dismissViewControllerAnimated:YES completion:nil];

}
////回到主页
//-(void)backZhuyeClcik{
//
//PlazeViewController*centerCTL=[[PlazeViewController alloc] init];
//    [self presentViewController:centerCTL animated:YES completion:nil];
//
//}
//


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
    return 44;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return  cityArr.count;
//   return 100;

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
//        bgView.backgroundColor=[UIColor redColor];
        bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
        cell.backgroundView=bgView;
//       [cell addSubview:bgView];
        [cell sendSubviewToBack:bgView];
        
        UIImageView*img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
        img.image=[UIImage imageNamed:@"line.png"];
        img.hidden=YES;
        
        [cell addSubview:img];
        if (indexPath.row == [cityArr count] - 1) {
            img.hidden=NO;
        }else{
            img.hidden=YES;
        }

//        UIImageView*img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
//        img.image=[UIImage imageNamed:@"line.png"];
//        [cell addSubview:img];
//        img.hidden=YES;
//        if ([cityArr lastObject]) {
//            img.hidden=NO;
//        }else{
//            img.hidden=YES;
//        }
//    
         }
    
      

    NSDictionary*cityDict=[cityArr objectAtIndex:indexPath.row];
    
    DetailTextView * dtView = (DetailTextView*)[cell viewWithTag:2000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[cityDict objectForKey:@"name"],[cityDict objectForKey:@"en_name"]];
    DLog(@"mLLLLL%@",str);
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[cityDict objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
