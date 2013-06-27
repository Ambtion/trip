//
//  PhotoDetailController.m
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PhotoDetailController.h"

@implementation PhotoDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[[PhotoDetailView alloc] initWithFrame:self.view.bounds imageInfo:nil]];
}
@end
