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
@synthesize singleCityName1;
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
    if ([self isIphone5]) {
        height=548;
    }else{
        height=460;
    }
    
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
    NSString * str = [NSString stringWithFormat:@"%@ %@",singleCityName,singleCityName1];
    [dtView setText:str WithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20] AndColor:[UIColor whiteColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:singleCityName1, nil] WithFont:[UIFont systemFontOfSize:16.f] AndColor:[UIColor whiteColor]];
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
    
    [[ASIRequest shareInstance] get:str header:nil delegate:self tag:5000 useCache:NO];



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
    return 44;
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
        DetailTextView * dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 12, 200, 40)];
        dtView.backgroundColor = [UIColor clearColor];
        dtView.tag = 5000;
        [cell addSubview:dtView];
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        bgView.backgroundColor = [UIColor clearColor];
        bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
        cell.backgroundView = bgView;
        UIImageView*img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
        img.image=[UIImage imageNamed:@"line.png"];
                [cell addSubview:img];
        img.hidden=YES;

       
        if (indexPath.row == [singleCityArr count] - 1) {
            img.hidden = NO;
        }else{
            img.hidden=YES;
        }
        

        
        
    }
    NSDictionary*cityDict=[singleCityArr objectAtIndex:indexPath.row];
    
    DetailTextView * dtView = (DetailTextView*)[cell viewWithTag:5000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[cityDict objectForKey:@"name"],[cityDict objectForKey:@"en_name"]];
    DLog(@"mLLLLL%@",str);
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[cityDict objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
    
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
