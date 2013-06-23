//
//  PlarzeViewController.m
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PlarzeViewController.h"

@interface PlarzeViewController ()

@end

@implementation PlarzeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    DLog(@"%@",NSStringFromCGRect(self.view.frame));
    self.view.backgroundColor = [UIColor redColor];
	// Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"%@",NSStringFromCGRect(self.view.frame));
}
- (void)viewWillAppear:(BOOL)animated
{
    
}
@end
