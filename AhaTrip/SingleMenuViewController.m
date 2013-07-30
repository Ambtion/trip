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
#import "QuartzCore/QuartzCore.h"
#import "DetailTextView.h"

@interface SingleMenuViewController ()

@end

@implementation SingleMenuViewController
@synthesize menuStr;
@synthesize selectID;
@synthesize menuStr1;


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES];
//    导航
    UIView* navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];
   
//   主菜单分类类型
//    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(15, 3, 180, 40)];
//    Accombodation.text=menuStr;
//    Accombodation.textColor=[UIColor whiteColor];
////    Accombodation.font=[UIFont systemFontOfSize:20];
//   Accombodation.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
//    Accombodation.backgroundColor=[UIColor clearColor];
//    [navView addSubview:Accombodation];
    NSLog(@"%@%@",menuStr,menuStr1);
    DetailTextView * dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 7, 200, 40)];
    dtView.backgroundColor = [UIColor clearColor];
    NSString * str = [NSString stringWithFormat:@"%@ %@",menuStr,menuStr1];
    [dtView setText:str WithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20] AndColor:[UIColor whiteColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:menuStr1, nil] WithFont:[UIFont systemFontOfSize:16.f] AndColor:[UIColor whiteColor]];
    [navView addSubview:dtView];
    departMentArr=[NSMutableArray array];

    [self requestSingleCategary];
    
//    分类表格
    departmentTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 44+10,302, self.view.frame.size.height-44-44-50) style:UITableViewStylePlain];
    departmentTable.backgroundColor = [UIColor clearColor];
    departmentTable.dataSource=self;
    departmentTable.delegate=self;
    departmentTable.separatorColor=mRGBColor(226, 226, 220);
    departmentTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:departmentTable];
    
    if ([self isIphone5]) {
        height=548;
       
    }else{
        height=460;
    
    }
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, height-55,320, 55)];
    
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
//    返回主页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(280-8, height-47, 40, 40)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
    //    主菜单的选项切换
    UIButton*selectMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectMenuBtn.frame=CGRectMake(280, 15, 30, 16);
    [selectMenuBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
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
    return 44;
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

        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;        
        DetailTextView * dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 12, 200, 40)];
        dtView.backgroundColor = [UIColor clearColor];
        dtView.tag = 1000;
        [cell addSubview:dtView];
        
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.backgroundColor = [UIColor clearColor];
        bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
        cell.backgroundView = bgView;
        UIImageView*img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
        img.image=[UIImage imageNamed:@"line.png"];
        [cell addSubview:img];
        img.hidden=YES;
        if (indexPath.row == [departMentArr count] - 1) {
            img.hidden = NO;
        }else{
            img.hidden=YES;
        }
        
        
}
    NSDictionary*cityDict=[departMentArr objectAtIndex:indexPath.row];

    DetailTextView * dtView = (DetailTextView*)[cell viewWithTag:1000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[cityDict objectForKey:@"name"],[cityDict objectForKey:@"en_name"]];
    DLog(@"mLLLLL%@",str);
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[cityDict objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SouSuoViewController*souSuoCTL=[[SouSuoViewController alloc] init];
    souSuoCTL.selectCAtegary=self.menuStr;
    NSLog(@"%@",souSuoCTL.selectCAtegary);
    [self presentViewController:souSuoCTL animated:YES completion:nil];
}

@end
