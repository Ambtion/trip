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
    UILabel * _likeLabel;
    UILabel * _commentLabel;
    UIButton * _likeButton;
    UIImage * _originalImage;
    UIImage * _blurImage;
    __weak UIViewController * _controller;
    NSTimer * _timer;
    BOOL _isMoveToRight;
    BOOL isAnimation;
}
- (id)initWithFrame:(CGRect)frame  controller:(UIViewController *)controller imageInfo:(NSDictionary *)info;
- (void)startBgAnimation;
- (void)stopAnimation;
@end
