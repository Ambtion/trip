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
    
    
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 30)];
    Accombodation.text=@"选择分类";
    Accombodation.backgroundColor=[UIColor clearColor];
    Accombodation.textColor=[UIColor whiteColor];
    Accombodation.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    [navView addSubview:Accombodation];
    menuArr=[NSMutableArray array];
    [self requestCategary];
//    表格
    menuTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 44+10, 302, self.view.frame.size.height-150) style:UITableViewStylePlain];
    menuTable.dataSource=self;
   menuTable.delegate=self;
    menuTable.backgroundColor=[UIColor clearColor];
    menuTable.separatorColor=[UIColor clearColor];
    
//    menuTable.separatorColor=mRGBColor(226, 226, 220);
    menuTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:menuTable];

    //    底部导航
    if ([self isIphone5]) {
        height=548;
    }
    else{
        height=460;
    
    }
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, height-55,320, 55)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10, height-42, 33, 33)];
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
    return 44;
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
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = mRGBColor(50, 200, 160);
        
        DetailTextView * dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 12, 200, 40)];
        dtView.backgroundColor = [UIColor clearColor];
        dtView.tag = 1000;
        [cell addSubview:dtView];
       
        
        UIImageView * bgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        bgView.backgroundColor = [UIColor redColor];
        bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
        cell.backgroundView = bgView;
        
        UIImageView*img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
        img.image=[UIImage imageNamed:@"line.png"];
        [cell.contentView addSubview:img];
        img.hidden=YES;
        if (indexPath.row == [menuArr count] - 1) {
            img.hidden = NO;
        }else{
            img.hidden = YES;
        }

    }
//    UILabel*cityLabel=(UILabel*)[cell viewWithTag:1000];
//    NSDictionary*cityDict=[menuArr objectAtIndex:indexPath.row];
//    cityLabel.text=[cityDict objectForKey:@"name"];
//    return cell;
    NSDictionary*cityDict=[menuArr objectAtIndex:indexPath.row];
    
    DetailTextView * dtView = (DetailTextView*)[cell viewWithTag:1000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[cityDict objectForKey:@"name"],[cityDict objectForKey:@"en_name"]];
    DLog(@"mLLLLL%@",str);
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[cityDict objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
//    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
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
