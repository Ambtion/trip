//
//  BusinessTimeController.m
//  AhaTrip
//
//  Created by sohu on 13-8-15.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "BusinessTimeController.h"

@interface BusinessTimeController ()

@end

@implementation BusinessTimeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.f];

    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload {
    [self setEndTimeLabel:nil];
    [self setStartTimeLabel:nil];
    [self setSeletedBgView:nil];
    [super viewDidUnload];
}
@end
