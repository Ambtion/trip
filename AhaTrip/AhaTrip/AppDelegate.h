//
//  AppDelegate.h
//  AhaTrip
//
//  Created by xuwenjuan on 13-6-18.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "CenterViewController.h"
#import "JASidePanelController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    UINavigationController *navigationController;
}
@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) DDMenuController *menuController;
//@property (strong, nonatomic) CenterViewController*viewController;

@property (strong, nonatomic) JASidePanelController *viewController;

@end

