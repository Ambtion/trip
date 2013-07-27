//
//  SingleMenuViewController.m
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "SingleMenuViewController.h"
#import "AllMenuViewController.h"
#import "SouSuoViewController.h"
#import "SelectPhotoViewController.h"
#import "PhotoViewController.h"
#import "Constants.h"
@interface SingleMenuViewController ()

@end

@implementation SingleMenuViewController
@synthesize menuStr;
@synthesize selectID;
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
    [self.navigationController setNavigationBarHidden:YES];
//    导航
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];
   
//   主菜单分类类型
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(5, 0, 180, 40)];
    Accombodation.text=menuStr;
    Accombodation.textColor=[UIColor whiteColor];
    Accombodation.font=[UIFont systemFontOfSize:18];
    Accombodation.backgroundColor=[UIColor clearColor];
    [navView addSubview:Accombodation];
   
    
//   数据类型
//    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"酒店",@"city",nil];
//    
//    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:@"平价旅馆",@"city",nil];
//    
//    NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:@"汽车旅馆",@"city",nil];
//    
//    NSDictionary *dic4=[NSDictionary dictionaryWithObjectsAndKeys:@"青年公寓",@"city",nil];
//    
//    NSDictionary *dic5=[NSDictionary dictionaryWithObjectsAndKeys:@"民宿",@"city",nil];
//    
//    departMentArr=[NSMutableArray arrayWithObjects:dic1,dic2,dic3,dic4,dic5,nil];
  
    departMentArr=[NSMutableArray array];
    [self requestSingleCategary];
    
//    分类表格
    departmentTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 44+10, self.view.frame.size.width-20, self.view.frame.size.height-44-44-50) style:UITableViewStylePlain];
    departmentTable.dataSource=self;
    departmentTable.delegate=self;
    departmentTable.separatorColor=mRGBColor(226, 226, 220);
    [self.view addSubview:departmentTable];
    
//    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44,320, 44)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
//    返回主页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(280, self.view.frame.size.height-44, 50, 44)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
    //    主菜单的选项切换
    UIButton*selectMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectMenuBtn.frame=CGRectMake(280, 5, 50, 30);
    [selectMenuBtn setImage:[UIImage imageNamed:@"detail.png"] forState:UIControlStateNormal];
    selectMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    selectMenuBtn.userInteractionEnabled=YES;
    [selectMenuBtn addTarget:self action:@selector(selectMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectMenuBtn];
    

    
}
//请求的request
-(void)requestSingleCategary{

    NSString*singleCityStr=@"http://yyz.ahatrip.info/api/subCategoryList";
    
    NSString*str=[NSString stringWithFormat:@"%@?category_id=%d&token=tRyW4rLBiJHffQ",singleCityStr,selectID];
    NSLog(@"%@",str);
    
    [[ASIRequest shareInstance] get:str header:nil delegate:self tag:6000 useCache:YES];


}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 6000 && request.responseStatusCode == 200)
    {
        NSDictionary *data =[request responseString].objectFromJSONString;
        departMentArr=[data objectForKey:@"sub_categories"];
        [departmentTable reloadData];
        
        
        
        
    }
    
}

//返回主页的点击事件
-(void)closeBtnBackMenu{

    [self dismissViewControllerAnimated:YES completion:nil];


}
-(void)selectMenu:(UIButton*)sender{
    AllMenuViewController*allMenu=[[AllMenuViewController alloc] init];
    
    [self presentViewController:allMenu animated:YES completion:nil];


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
    return  departMentArr.count;
//       return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *topicCell = @"TopicCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:topicCell];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = mRGBColor(50, 200, 160);
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UILabel*citylabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        citylabel.tag=1000;
        //        citylabel.text=@"women";
        [cell addSubview:citylabel];
        
               
        
    }
    UILabel*cityLabel=(UILabel*)[cell viewWithTag:1000];
    NSDictionary*cityDict=[departMentArr objectAtIndex:indexPath.row];
    cityLabel.text=[cityDict objectForKey:@"name"];
    
        
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary*cityIdDict=[cityArr objectAtIndex:indexPath.row];
//    NSString*cityid=[cityIdDict objectForKey:@"id"];
//    
//    CityTwoViewController*city=[[CityTwoViewController alloc] initWithNibName:@"CityTwoViewController" bundle:nil];
//    city.singleCityId=cityid;
//    [self.navigationController pushViewController:city animated:YES];
//    SouSuoViewController*sousuocountry=[[SouSuoViewController alloc] initWithNibName:@"SouSuoViewController" bundle:nil];
//    [self.navigationController pushViewController:sousuocountry animated:YES];
//    SelectPhotoViewController*selectPhoto=[[SelectPhotoViewController alloc] init];
//    [self.navigationController pushViewController:selectPhoto animated:YES];
//    PhotoViewController*photoCTL=[[PhotoViewController alloc] init];
//    [self presentViewController:photoCTL animated:YES completion:nil];
    SouSuoViewController*souSuoCTL=[[SouSuoViewController alloc] init];
    souSuoCTL.selectCAtegary=self.menuStr;
    NSLog(@"%@",souSuoCTL.selectCAtegary);
    [self presentViewController:souSuoCTL animated:YES completion:nil];
}

@end
