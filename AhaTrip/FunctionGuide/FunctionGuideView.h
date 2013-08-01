//
//  FunctionguideScroll.h
//  SohuCloudPics
//
//  Created by sohu on 12-11-15.
//
//

#import <UIKit/UIKit.h>
//#import "SMPageControl.h"


#define FUNCTIONSHOWED [NSString stringWithFormat:@"__FUNCTIONSHOWED__%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]

@class FunctionGuideView;
@protocol FunctionGuideViewDelegate <NSObject>
@optional
- (void)functionGuideView:(FunctionGuideView *)guideView loginButtonClick:(UIButton *)button;
@end
@interface FunctionGuideView : UIView <UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    SMPageControl * _pageControll;
    id<FunctionGuideViewDelegate> delegate;
}
+ (void)showViewWithDelegate:(id<FunctionGuideViewDelegate>)delegate;
+ (BOOL)shouldShowGuide;
@end
