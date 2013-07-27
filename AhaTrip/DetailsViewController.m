//
//  DetailsViewController.m
//  XQSearchPlaces
//
//  Created by iObitLXF on 5/20/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "DetailsViewController.h"
#import "ChildMapView.h"
#import "UITableView+ZGParallelView.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize placeDetailVO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setUI
{
    self.myNavItem.title = self.placeDetailVO.pNameStr;
    
    ChildMapView *aView = [ChildMapView getInstanceWithNibWithPlaceDetailVO:self.placeDetailVO];
    [aView setUI];
    [self.tableView addParallelViewWithUIView:aView];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyNavItem:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
         return 44.;
    }
    return 60;
}

#pragma mark -table dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        static NSString *CellIdentifier = @"NameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"Name:";
        cell.detailTextLabel.text = self.placeDetailVO.pNameStr;
        return cell;
    }
   else
   {
       static NSString *CellIdentifier = @"InfoCell";
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       if (cell == nil) {
           cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
           cell.accessoryType = UITableViewCellAccessoryNone;
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
       }
       cell.textLabel.text = @"Vicinity:";
       cell.detailTextLabel.text = self.placeDetailVO.pVicinityStr;
       return cell;
   }
    return nil;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

@end
