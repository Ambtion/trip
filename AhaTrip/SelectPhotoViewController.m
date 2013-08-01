//
//  SelectPhotoViewController.m
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "SelectPhotoViewController.h"

@interface SelectPhotoViewController ()

@end

@implementation SelectPhotoViewController

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
    UIView*navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:navView];
    
    
        
    UILabel*Accombodation=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 30)];
    Accombodation.text=@"添加图片";
    [navView addSubview:Accombodation];
    
    UIButton*selectPhotoBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
   selectPhotoBtn.frame=CGRectMake(50, 100, 150, 100);
    [selectPhotoBtn setTitle:@"选择照片" forState:UIControlStateNormal];
    [selectPhotoBtn addTarget:self action:@selector(selectImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:selectPhotoBtn];
}
//从相册选择
-(void)selectImageBtn:(UIButton*)sender{



}
//从照相机选择
-(void)selectCameraBtn:(UIButton*)sender{


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
