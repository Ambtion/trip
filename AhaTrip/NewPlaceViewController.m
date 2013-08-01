//
//  NewPlaceViewController.m
//  AhaTrip
//
//  Created by xuwenjuan on 13-8-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "NewPlaceViewController.h"
#import "Constants.h"
@interface NewPlaceViewController ()

@end

@implementation NewPlaceViewController

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
    backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    backView.backgroundColor=mRGBColor(50, 200, 160);
    [self.view addSubview:backView];
    serchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(15, 6, 236, 44)];
    serchBar.delegate=self;
    serchBar.placeholder = @"搜索附近位置";

     serchBar.showsCancelButton = YES;
    serchBar.keyboardType =  UIKeyboardTypeDefault;
    //为UISearchBar添加背景图片
    UIView *segment = [serchBar.subviews objectAtIndex:0];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/search_bar_bg.png"]];
    [segment addSubview: bgImage];
    [backView addSubview:serchBar];
    
    closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(260, 7, 55, 44);
    [closeBtn setImage:[UIImage imageNamed:@"bottom_back.png"] forState:UIControlStateNormal];
    [backView addSubview:closeBtn];
    
    addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame=CGRectMake(0, 56, 320, 42);
    [self.view addSubview:addBtn];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 56, 100, 40)];
    label.text=@"添加位置";
     label.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    [self.view addSubview:label];
    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
