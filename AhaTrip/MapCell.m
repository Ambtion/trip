//
//  mapCell.m
//  Match3Draft
//
//  Created by iObitLXF on 2/21/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "MapCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MASearch.h"
#import "UIImageView+DispatchLoad.h"
#import "DealHelper.h"
#define ANGLE_TO_PI M_PI/180
#define SPEEDTIME_TO_PI M_PI/180

@implementation MapCell
@synthesize buttonItem1,buttonItem2,buttonItem3;
@synthesize labelTitle;
@synthesize placeDetailVO;

+(MapCell*)getInstanceWithNibWithBlock:(ClickButtonBlock)aBlock
{
    MapCell *aView = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"MapCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[MapCell class]]){
            
            aView = (MapCell *)obj;
            break;
        }
    }
    aView.blockButton = aBlock;
    return aView;

}

#pragma mark - methods
-(void)toAppearItemsView
{
     self.labelTitle.text = self.placeDetailVO.name;
    [self.imageViewBg setImageFromUrl:self.placeDetailVO.url completion:^{
    }];
    [[DealHelper sharedInstance]dealViewRoundCorners:self.imageViewBg radius:self.imageViewBg.bounds.size.width/2];
    [[DealHelper sharedInstance]dealScaleView:self.buttonItem1 scale:0.1];
}
-(void)appearItemsViews:(UIView *)aView tag:(NSNumber *)aTagNum
{
     aView.alpha = 1;
    [[DealHelper sharedInstance]dealViewRoundCorners:aView radius:aView.bounds.size.width/2];
    [UIView animateWithDuration:0.3
                  animations:^{
                      [[DealHelper sharedInstance]dealScaleView:aView scale:10];
                     
                                              
                  }completion:^(BOOL finished){
                  
                      if ([aTagNum intValue]!=0) {
                          [self animationOfRoundBgImageView:aView
                                                     center:self.imageViewBg.center
                                                     radius:self.imageViewBg.bounds.size.width/2
                                                startAgngle:-60*ANGLE_TO_PI
                                                  endAgngle:-60*ANGLE_TO_PI+35*[aTagNum intValue]*ANGLE_TO_PI
                                                  clockwise:NO
                                                   duration:20*[aTagNum intValue]*ANGLE_TO_PI/M_PI*0.5];//
                      }
     
                      
                  }];
    
}


//围绕大图中心点旋转的动画
-(void)animationOfRoundBgImageView:(UIView *)aView          //目标view
                            center:(CGPoint)aCenter         //围绕的中心点（原点）
                            radius:(CGFloat)aRadius         //围绕的半径
                       startAgngle:(CGFloat)aStartAngle     //开始的角度
                         endAgngle:(CGFloat)aEndAngle       //结束的角度
                         clockwise:(BOOL)aClockwise         //是否逆时针（0：顺时针，1：逆时针）
                          duration:(CGFloat)aDur            //动画时间
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = aDur;
    
    CGMutablePathRef ovalfromarc = CGPathCreateMutable();
    CGAffineTransform t2 = CGAffineTransformConcat(CGAffineTransformMakeTranslation(-aCenter.x, -aCenter.y), CGAffineTransformMakeTranslation(aCenter.x, aCenter.y));
    //CGPathAddArc(动画的路径,layer的transform,弧的圆心点x,弧的圆心点y,起始的角度点,结束的角度点,是否顺时针)
    CGPathAddArc(ovalfromarc, &t2, aCenter.x, aCenter.y, aRadius,aStartAngle, aEndAngle, aClockwise);
    
    pathAnimation.path = ovalfromarc;
    CGPathRelease(ovalfromarc);
    
    [pathAnimation setDelegate:self];
    [pathAnimation setValue:aView forKey:@"BtnAni"];
    
    [aView.layer addAnimation:pathAnimation forKey:@"curve"];
   

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UIView *btnView = [anim valueForKey:@"BtnAni"];
    
    if (flag && btnView) {
//        CGPoint currentRect = [[btnView.layer presentationLayer]position];
        CGPoint currentRect = [btnView.layer position];
        btnView.layer.position = currentRect;
        return;
    }
}

#pragma mark - action
- (IBAction)clickButton:(UIButton *)sender {
    ButtonType aType = ButtonType_Profile;
    
    switch (sender.tag) {
        case 100:
            NSLog(@"Click button1");
            aType = ButtonType_Profile;
            break;
        case 101:
            NSLog(@"Click button2");
            aType = ButtonType_Distance;
            break;
        case 102:
            NSLog(@"Click button3");
            aType = ButtonType_More;
            break;
            
        default:
            break;
    }
    
    self.blockButton(aType);
}

@end
