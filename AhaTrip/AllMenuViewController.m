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
#import "RequestManager.h"

@implementation AllMenuViewController
@synthesize delegate;

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
    height = [[UIScreen mainScreen] bounds].size.height - 20.f;
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

}


#pragma request
-(void)requestCategary
{
    [RequestManager getAllCateroyWithToke:nil success:^(NSString *response) {
        NSDictionary *data =[response JSONValue];
        menuArr = [data objectForKey:@"categories"];
        [menuTable reloadData];
    } failure:^(NSString *error) {
        
    }];
}

-(void)closeBtnBackMenu
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuArr.count;    
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
        bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
        cell.backgroundView = bgView;
        
        UIImageView*img=[[UIImageView alloc] initWithFrame:CGRectMake(0, 43, 300, 1)];
        img.image=[UIImage imageNamed:@"line.png"];
        img.tag = 10000;
        [cell.contentView addSubview:img];
    }
    UIView * view = [cell viewWithTag:10000];
    view.hidden = menuArr.count - 1 != indexPath.row;
    NSDictionary*cityDict=[menuArr objectAtIndex:indexPath.row];
    
    DetailTextView * dtView = (DetailTextView*)[cell viewWithTag:1000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",[cityDict objectForKey:@"name"],[cityDict objectForKey:@"en_name"]];
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:[cityDict objectForKey:@"en_name"], nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSDictionary * dict=[menuArr objectAtIndex:indexPath.row];
    if ([delegate respondsToSelector:@selector(allMenuViewChangeCateroy:)])
        [delegate allMenuViewChangeCateroy: [[dict objectForKey:@"id"] integerValue] - 1];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
