//
//  AboutViewController.h
//  AhaTrip
//
//  Created by sohu on 13-8-19.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
- (IBAction)backbuttonClick:(UIButton *)sender;
- (IBAction)tapGestureClick:(UITapGestureRecognizer *)sender;
@end
