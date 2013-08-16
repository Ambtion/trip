//
//  HasWiFiController.m
//  AhaTrip
//
//  Created by sohu on 13-8-16.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "HasWiFiController.h"

@interface HasWiFiController ()
{
    NSInteger hasWifiIndex;
}

@end

@implementation HasWiFiController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.f];
    hasWifiIndex = -1;
    [self addTabBar];
}
- (void)addTabBar
{
    //加载底部导航
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    UIImageView * backimageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, height-55, self.view.bounds.size.width, 55)];
    backimageView.backgroundColor=[UIColor blackColor];
    [backimageView setUserInteractionEnabled:YES];
    [self.view addSubview:backimageView];
    //返回国家页的listmenu页的按钮
    UIButton * closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10 , 0, 50, 55)];
    closeMenuBtn.contentMode=UIViewContentModeCenter;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu:) forControlEvents:UIControlEventTouchUpInside];
    [backimageView addSubview:closeMenuBtn];
    
    //  返回主页的按钮
    UIButton*closeAll=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeAll setFrame:CGRectMake(280 - 8 - 20,0, 60, 55)];
    closeAll.contentMode = UIViewContentModeCenter;
    [closeAll setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
    [closeAll addTarget:self action:@selector(finished:) forControlEvents:UIControlEventTouchUpInside];
    [backimageView addSubview:closeAll];
}

- (void)closeBtnBackMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finished:(UIButton *)button
{
    if ([delegate respondsToSelector:@selector(wifiControllerDidSeletedWithIndexTag:)]) {
        [delegate wifiControllerDidSeletedWithIndexTag:hasWifiIndex];
    }
    DLog(@"%d",hasWifiIndex);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapGesture:(id)sender
{
    UIGestureRecognizer * ges = (UIGestureRecognizer *)sender;
    UIView * view = [ges view];
    [UIView animateWithDuration:0.3 animations:^{
        self.seletedBgView.center = CGPointMake(self.seletedBgView.center.x, view.center.y);
    } completion:^(BOOL finished) {
        hasWifiIndex = view.tag - 100;
    }];
}
@end
