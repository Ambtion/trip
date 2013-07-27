//
//  PhotoDetailView.h
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailTextIcon.h"

@interface PhotoDetailViewDataSource : NSObject
@property(nonatomic,strong)DesInfoViewDataSource * dataSource;
@property(nonatomic,strong)NSString * imageUrl;
@end

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
    NSTimer * _timer;
    BOOL _isMoveToRight;
    BOOL isAnimation;
    __weak UIViewController * _controller;
    PhotoDetailViewDataSource * _dataSource;
}
@property(nonatomic,strong)PhotoDetailViewDataSource * dataSource;

- (id)initWithFrame:(CGRect)frame  controller:(UIViewController *)controller;
- (void)startBgAnimation;
- (void)stopAnimation;
@end
