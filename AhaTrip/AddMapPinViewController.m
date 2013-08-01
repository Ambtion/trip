//
//  AddMapPinViewController.m
//  AhaTrip
//
//  Created by xuwenjuan on 13-7-10.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import "AddMapPinViewController.h"
#import <MapKit/MapKit.h>

@interface AddMapPinViewController ()

@end

@implementation AddMapPinViewController

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
    [[LocationManager sharedInstance] showMapView];
     
 	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
