//
//  FGuideViewManager.h
//  AhaTrip
//
//  Created by sohu on 13-9-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FGuideView;
@protocol FGuideViewDelegate <NSObject>
- (void)fguideViewdidDisAppear:(FGuideView *)guideView;
@end
@interface FGuideView : UIImageView
@property(assign,nonatomic)id delegate;
@end


@interface FGuideViewManager : UIView<FGuideViewDelegate>

{
    NSMutableArray * _imageArray;
    UIView * _superView;
}
+ (void)showFGuideViewWithImageaArray:(NSArray *)array superController:(UIViewController *)controller;
@end
