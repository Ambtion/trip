//
//  SingleMenuViewController.m
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "SingleMenuViewController.h"
#import "AllMenuViewController.h"
#import "CountryListController.h"
#import "SelectPhotoViewController.h"
#import "SeletedPhotoMethodController.h"
#import "Constants.h"
#import "QuartzCore/QuartzCore.h"
#import "DetailTextView.h"


@implementation SingleMenuViewController
@synthesize cateroyId = _cateroyId;
@synthesize menuCStr;
@synthesize menuEStr;
@synthesize delegate;

- (id)initWithCateroyId:(PicUploadCateroy)AcateroyId
{
    self = [super init];
    if (self) {
        self.cateroyId = AcateroyId;
    }
    return self;
}

//每一个分类
- (NSString *)getCateroyCStringById:(PicUploadCateroy)cateroyID
{
    
    switch (cateroyID) {
        case KCateroySight:
            return @"景观";
        case KCateroyShopping:
            return @"购物";
        case KCateroyDinner:
            return @"美食";
        case KCateroyHotel:
            return @"住宿";
        case KCateroyDrink:
            return @"饮品";
        case KCateroyEntertainment:
            return @"娱乐";
        default:
            break;
    }
    return nil;
}
- (NSString *)getCateroyEStringById:(PicUploadCateroy)cateroyID
{
    switch (cateroyID) {
        case KCateroySight:
            return @"View";
        case KCateroyShopping:
            return @"Shopping";
        case KCateroyDinner:
            return @"Food";
        case KCateroyHotel:
            return @"Accommodation";
        case KCateroyDrink:
            return @"Drink";
        case KCateroyEntertainment:
            return @"Entertainment";
        default:
            break;
    }
    return nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    //  导航
    UIView* navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor= mRGBColor(50, 200, 160);
    [self.view addSubview:navView];
    if (!_dtView) {
        _dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 7, 200, 40)];
        _dtView.backgroundColor = [UIColor clearColor];
        [self setBarTitle];
    }
    
    [navView addSubview:_dtView];
    
    _height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    
    _departMentArr = [NSMutableArray array];
    
    //    分类表格
    _departmentTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 54,302, _height - 54 - 55 - 10) style:UITableViewStylePlain];
    _departmentTable.backgroundColor = [UIColor clearColor];
    _departmentTable.dataSource=self;
    _departmentTable.delegate=self;
    _departmentTable.separatorColor = mRGBColor(226, 226, 220);
    _departmentTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:_departmentTable];
    
    _bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, _height- 55,320, 55)];
    _bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_bottomBar];
    
    //    返回主页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(280-8, _height - 47, 40, 40)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setCateroyId:(PicUploadCateroy)cateroyId
{
    _cateroyId = cateroyId;
    self.menuCStr = [self getCateroyCStringById:self.cateroyId];
    self.menuEStr = [self getCateroyEStringById:self.cateroyId];
    [self setBarTitle];
    [self requestSingleCategary];
}
- (void)setBarTitle
{
    NSString * str = [NSString stringWithFormat:@"%@ %@",menuCStr,menuEStr];
    if (!_dtView) {
        _dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 7, 200, 40)];
        _dtView.backgroundColor = [UIColor clearColor];
    }
    [_dtView setText:str WithFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:20] AndColor:[UIColor whiteColor]];
    [_dtView setKeyWordTextArray:[NSArray arrayWithObjects:menuEStr, nil] WithFont:[UIFont systemFontOfSize:16.f] AndColor:[UIColor whiteColor]];
}

//请求的request
-(void)requestSingleCategary
{
    
    [RequestManager getSubCateroyWithToken:nil WithCateroy_Id:_cateroyId + 1 success:^(NSString *response) {
        NSDictionary  * data =[response JSONValue];
        [_departMentArr removeAllObjects];
        _departMentArr = [data objectForKey:@"sub_categories"];
        [_departmentTable reloadData];
    } failure:^(NSString *error) {
    }];
}

//返回主页的点击事件
-(void)closeBtnBackMenu:(id)sender
{
    if ([delegate respondsToSelector:@selector(singleClickNavBarRightButton:)])
        [delegate singleClickNavBarRightButton:sender];
}
-(void)selectMenu:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(singleClickTabBarRightButton:)])
        [delegate singleClickTabBarRightButton:sender];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _departMentArr.count;
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
        img.tag = 200000;
        [cell addSubview:img];
    }
    UIView * lineView = [cell viewWithTag:200000];
    lineView.hidden = indexPath.row != [_departMentArr count] - 1;
    NSDictionary*cityDict=[_departMentArr objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([delegate respondsToSelector:@selector(singleSelectedSubCateroyWihtInfo:)]) {
        [delegate singleSelectedSubCateroyWihtInfo:[_departMentArr objectAtIndex:indexPath.row]];
    }
}

@end
