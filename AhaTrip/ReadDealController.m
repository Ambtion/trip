//
//  SCPReadDealController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-13.
//
//

#import "ReadDealController.h"


@implementation ReadDealController
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    CGRect rect = self.view.bounds;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:rect];
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 300, 5700/2.f)];
    imageview.image = [UIImage imageNamed:@"serviceitem.png"];
    imageview.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:imageview];
    [scrollView setContentSize:CGSizeMake(imageview.bounds.size.width, imageview.bounds.size.height + 50)];
    [self.view addSubview:scrollView];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1.f];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = BASEGREENCOLOR;
    [self.view addSubview:view];
    
    _backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backbutton.frame = CGRectMake(5, 2, 44, 44);
    [_backbutton setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [_backbutton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backbutton];
    
}

- (void)back:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
