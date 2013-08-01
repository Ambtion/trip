//
//  DealHelper.h
//  Match3Draft
//
//  Created by iObitLXF on 2/21/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealHelper : NSObject

+(DealHelper *)sharedInstance;

- (void)dealViewRoundCorners:(UIView *)aView radius:(CGFloat)aRadius;
- (void)dealViewShadow:(UIView *)aView radius:(CGFloat)aRadius;
- (void)dealScaleView:(UIView *)aView scale:(CGFloat)aScale;

@end
