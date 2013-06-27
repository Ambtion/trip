//
//  PhotoDetailView.h
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextIcon.h"

@interface PhotoDetailView : UIView<DetailTextIconAnimationDelegate>
{
    UIImageView * _bgImageView;
    NSDictionary * _infoDic;
    DetailTextIcon * _detailIcon;
}
- (id)initWithFrame:(CGRect)frame imageInfo:(NSDictionary *)info;
@end
