//
//  HomeAccountPage.h
//  AhaTrip
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSegMent.h"
#import "PortraitView.h"

@interface HomeAccountPage : UIView
{
    UIImageView * _bgImageView;
    PortraitView* _portraitImageView;
    UILabel * _nameLabel;
    UILabel * _desLabel;
    HomeSegMent * _segMent;
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
