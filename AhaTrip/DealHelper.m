//
//  DealHelper.m
//  Match3Draft
//
//  Created by iObitLXF on 2/21/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "DealHelper.h"
#import <QuartzCore/QuartzCore.h>

static DealHelper *dealHelper = nil;

@implementation DealHelper

+(DealHelper *)sharedInstance
{
    static dispatch_once_t done;
    // 一次性执行：
	dispatch_once(&done, ^{
        dealHelper = [[DealHelper alloc] init];
    });
	return dealHelper;

}


//切成圆脚
- (void)dealViewRoundCorners:(UIView *)aView radius:(CGFloat)aRadius
{
    [aView.layer setMasksToBounds:YES];
    [aView.layer setCornerRadius:aRadius];
    aView.layer.borderColor = [[UIColor redColor] CGColor];
    aView.layer.borderWidth = 2.0;
//    aView.backgroundColor=[UIColor whiteColor];

}

//阴影
- (void)dealViewShadow:(UIView *)aView radius:(CGFloat)aRadius
{
    //阴影又圆角得layer
    CALayer *shadowCorner = [CALayer layer];
    shadowCorner.frame = aView.bounds;
    shadowCorner.backgroundColor = [UIColor whiteColor].CGColor;
    shadowCorner.shadowOffset = CGSizeMake(0, 1); //数字变大阴影效果得范围变宽
    shadowCorner.shadowColor = [[UIColor blackColor] CGColor];
    shadowCorner.shadowOpacity = 0.3;
    shadowCorner.shadowRadius = 1.0;//阴影效果得半径与shadowOffset共同控制阴影效果
    shadowCorner.cornerRadius = aRadius;//圆角半径
    //    shadowCorner.masksToBounds = YES; //这行代码会屏蔽掉阴影效果
    //    shadowCorner.borderColor = [[UIColor grayColor] CGColor];
    //    shadowCorner.borderWidth = 2;
    [aView.layer addSublayer:shadowCorner];
    aView.backgroundColor = [UIColor clearColor];//清空本身view得layer得背景色，不然圆角显示不成功，因为shadowCorner得圆角部分透明，透视盗test得layer非圆角颜色，显示不出圆角效果

}

//等比例缩放
- (void)dealScaleView:(UIView *)aView scale:(CGFloat)aScale
{
    //进行缩放
    CGAffineTransform currentTransform = aView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, aScale,aScale);
    [aView setTransform:newTransform];
    
}
@end
