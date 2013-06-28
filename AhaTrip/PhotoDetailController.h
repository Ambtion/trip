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

@interface PhotoDetailController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    SMPageControl * _pageControll;
    
}

@end
