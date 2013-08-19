//
//  AboutViewController.m
//  AhaTrip
//
//  Created by sohu on 13-8-19.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "AboutViewController.h"
#import "ReadDealController.h"

@interface AboutViewController ()
{
    CGRect touchRect;
}
@end

@implementation AboutViewController
@synthesize versionLabel = _versionLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect labelRect = CGRectZero;
    UIImage * bgImage = nil;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString * version = [infoDic objectForKey:@"CFBundleVersion"];
    DLog(@"%@",infoDic);
    
    if ([self isIphone5]) {
        bgImage = [UIImage imageNamed:@"about_1136.png"];
        labelRect = CGRectMake(0, 664 /2.f, 320, 30);
        touchRect = CGRectMake(100, 664 /2.f + 100, 120, 80);
    }else{
        bgImage = [UIImage imageNamed:@"about_960.png"];
        labelRect = CGRectMake(0, 536 /2.f, 320, 30);
        touchRect = CGRectMake(100, 536 /2.f + 100, 120, 80);
    }
    
    self.bgImageView.image = bgImage;
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",version];
    self.versionLabel.frame = labelRect;
    
}

- (void)viewDidUnload {
    [self setBgImageView:nil];
    [super viewDidUnload];
}
- (IBAction)backbuttonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapGestureClick:(UITapGestureRecognizer *)sender {
    [self.navigationController pushViewController:[[ReadDealController alloc] init] animated:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    DLog(@"%@ :::::%@",NSStringFromCGPoint([touch locationInView:self.view]),NSStringFromCGRect(touchRect));
    return CGRectContainsPoint(touchRect, [touch locationInView:self.view]);
}
@end
