//
//  PhotoDetailController.h
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDetailView.h"
#import "SMPageControl.h"
#import "PortraitView.h"

@interface PhotoDetailController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    SMPageControl * _pageControll;
    PortraitView * _portraitImage;
    UILabel * _nameLabel;
    NSString * _titleId;
    NSDictionary * _dataInfo;
    UIButton * _backButton;
    BOOL isLiked;
    int  likeCount;
    int  commentCount;
}
- (id)initWithTitleId:(NSString *)titleId;
@end
