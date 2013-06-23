//
//  CusSearchDisplayController.m
//  AhaTrip
//
//  Created by Qu on 13-6-23.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "CusSearchDisplayController.h"

@implementation CusSearchDisplayController
- (void)setActive:(BOOL)visible animated:(BOOL)animated;
{
    if(self.active == visible) return;
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [super setActive:visible animated:animated];
    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    if (visible) {
        [self.searchBar becomeFirstResponder];
    } else {
        [self.searchBar resignFirstResponder];
    }
}

@end
