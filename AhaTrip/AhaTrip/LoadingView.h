//
//  LoadingView.h
//  ILovePostcardHD
//
//  Created by 振东 何 on 12-7-18.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kPROffsetY      95.f
#define kPRMargin       6.f
#define kPRLabelHeight  20.f
#define kPRLabelWidth   70.f
#define kPRArrowWidth   23.f
#define kPRArrowHeight  60.f

#define kTextColor [[UIColor darkTextColor] colorWithAlphaComponent:1.0]
#define kPRBGColor [[UIColor orangeColor] colorWithAlphaComponent:0.1]
#define kPRAnimationDuration 0.18f

typedef enum {
    kPRStateNormal  = 0,
    kPRStatePulling = 1,
    kPRStateLoading = 2,
    kPRStateHitTheEnd = 3
} PRState;

@interface LoadingView : UIView {
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIImageView *_arrowView;
    UIActivityIndicatorView *_activityView;
    CALayer *_arrow;
    BOOL _loading;
}
@property (nonatomic,getter = isLoading) BOOL loading;
@property (nonatomic,getter = isAtTop) BOOL atTop;
@property (nonatomic) PRState state;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;

- (void)updateRefreshDate:(NSDate *)date;
- (void)setState:(PRState)state animated:(BOOL)animated;

@end
