//
//  AllMenuViewController.m
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "AllMenuViewController.h"
#import "Constants.h"
#import "SingleMenuViewController.h"
@interface AllMenuViewController ()

@end

@implementation AllMenuViewController
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
//    topbar
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
     navView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:navView];
    
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 30)];
    Accombodation.text=@"选择分类";
    Accombodation.backgroundColor=[UIColor clearColor];
    Accombodation.textColor=[UIColor whiteColor];
    Accombodation.font=[UIFont systemFontOfSize:18];
    [navView addSubview:Accombodation];
    
//    数据类型
//    NSDictionary *dic1=[NSDictionary dictionaryWithObjectsAndKeys:@"景观",@"city",nil];
//    
//    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:@"购物",@"city",nil];
//    
//    NSDictionary *dic3=[NSDictionary dictionaryWithObjectsAndKeys:@"美食",@"city",nil];
//    
//    NSDictionary *dic4=[NSDictionary dictionaryWithObjectsAndKeys:@"住宿",@"city",nil];
//    
//    NSDictionary *dic5=[NSDictionary dictionaryWithObjectsAndKeys:@"饮品",@"city",nil];
//    
//    NSDictionary *dic6=[NSDictionary dictionaryWithObjectsAndKeys:@"娱乐",@"city",nil];
//    
//    NSDictionary *dic7=[NSDictionary dictionaryWithObjectsAndKeys:@"其他",@"city",nil];
//    menuArr=[NSMutableArray arrayWithObjects:dic1,dic2,dic3,dic4,dic5,dic6,dic7, nil];
  
    menuArr=[NSMutableArray array];
    [self requestCategary];
//    表格
    menuTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 44+10, self.view.frame.size.width-20, self.view.frame.size.height-150) style:UITableViewStylePlain];
    menuTable.dataSource=self;
   menuTable.delegate=self;
    menuTable.separatorColor=mRGBColor(226, 226, 220);
    menuTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:menuTable];

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


#pragma request
-(void)requestCategary{
    NSString*singleCityStr=@"http://yyz.ahatrip.info/api/categoryList?token=tRyW4rLBiJHffQ";
    
//    NSString*str=[NSString stringWithFormat:@"%@?country_id=%@",singleCityStr,singleCityId];
//    NSLog(@"%@",str);
    
    [[ASIRequest shareInstance] get:singleCityStr header:nil delegate:self tag:5 useCache:YES];
    
    
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 5 && request.responseStatusCode == 200)
    {
        NSDictionary *data =[request responseString].objectFromJSONString;
        menuArr=[data objectForKey:@"categories"];
        [menuTable reloadData];
        
        
        
        
    }
    
}

-(void)closeBtnBackMenu{

    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dis];

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
    return menuArr.count;
    //    return 100;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *topicCell = @"TopicCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:topicCell];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = mRGBColor(50, 200, 160);
        UILabel*citylabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        citylabel.tag=1000;
        //        citylabel.text=@"women";
        [cell addSubview:citylabel];
        
        
        
    }
    UILabel*cityLabel=(UILabel*)[cell viewWithTag:1000];
    NSDictionary*cityDict=[menuArr objectAtIndex:indexPath.row];
    cityLabel.text=[cityDict objectForKey:@"name"];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSDictionary*dict=[menuArr objectAtIndex:indexPath.row];
    NSString*selectMnu=[dict objectForKey:@"name"];
    self.selectID=[[dict objectForKey:@"id"] integerValue];
    
    SingleMenuViewController*singleMenu=[[SingleMenuViewController alloc] init];
    singleMenu.menuStr=selectMnu;
    singleMenu.selectID=self.selectID;
    
    [self presentViewController:singleMenu animated:YES completion:nil];
}

@end
