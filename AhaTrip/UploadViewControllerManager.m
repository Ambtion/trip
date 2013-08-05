//
//  UploadViewManager.m
//  AhaTrip
//
//  Created by sohu on 13-8-5.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "UploadViewControllerManager.h"

@interface UploadViewControllerManager ()
@property(nonatomic,strong)NSMutableArray * menuArr;
@end

@implementation UploadViewControllerManager

- (id)initWithCateroyId:(PicUploadCateroy)cateroyId
{
    SingleMenuViewController * sigle =  [[SingleMenuViewController alloc] initWithCateroyId:cateroyId];
    sigle.delegate = self;
    if (self = [super initWithRootViewController:sigle]) {
        _cateroyId = cateroyId;
        [self.navigationBar setHidden:YES];
    }
    return self;
}
#pragma mark -  SingeMenu
- (void)singleClickNavBarRightButton:(id)object
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)singleClickTabBarRightButton:(id)object
{
    AllMenuViewController * allMenu=[[AllMenuViewController alloc] init];
    allMenu.delegate = self;
    [self presentModalViewController:allMenu animated:YES];
}
- (void)singleSelectedSubCateroyWihtInfo:(NSDictionary *)info
{
    _subCateroyInfo = info;
    SouSuoViewController * souSuoCTL = [[SouSuoViewController alloc] init];
    [self pushViewController:souSuoCTL animated:YES];
}

#pragma mark Cateroy
- (void)allMenuViewChangeCateroy:(PicUploadCateroy)cateroy
{
    SingleMenuViewController * root = [[self viewControllers] objectAtIndex:0];
    root.cateroyId = cateroy;
}
@end
