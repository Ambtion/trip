//
//  BusinessTimeController.m
//  AhaTrip
//
//  Created by sohu on 13-8-15.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "BusinessTimeController.h"
#import "ActionSheetDatePicker.h"

@interface BusinessTimeController ()
{
    BOOL _isStartTime;
    NSDate * _preDate;
}
@end

@implementation BusinessTimeController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.f];
    self.seletedBgView.backgroundColor = BASEGREENCOLOR;
    [self addTabBar];
}
- (void)addTabBar
{
    //加载底部导航
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    UIImageView * backimageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, height-55, self.view.bounds.size.width, 55)];
    backimageView.backgroundColor=[UIColor blackColor];
    [backimageView setUserInteractionEnabled:YES];
    [self.view addSubview:backimageView];
    //返回国家页的listmenu页的按钮
    UIButton * closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10 , 0, 50, 55)];
    closeMenuBtn.contentMode=UIViewContentModeCenter;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBackMenu:) forControlEvents:UIControlEventTouchUpInside];
    [backimageView addSubview:closeMenuBtn];
    
    //  返回主页的按钮
    UIButton*closeAll=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeAll setFrame:CGRectMake(280 - 8 - 20,0, 60, 55)];
    closeAll.contentMode = UIViewContentModeCenter;
    [closeAll setImage:[UIImage imageNamed:@"button_ok.png"] forState:UIControlStateNormal];
    [closeAll addTarget:self action:@selector(finished:) forControlEvents:UIControlEventTouchUpInside];
    [backimageView addSubview:closeAll];
}

- (void)closeBtnBackMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)finished:(UIButton *)button
{
    if ([self labelhastext:self.startCotent] && [self labelhastext:self.endContent] ) {
        DLog(@"%@ %@",self.startCotent.text , self.endContent.text);
        if ([delegate respondsToSelector:@selector(businessTimeControllerDidSeletedTime:endTime:)])
            [delegate businessTimeControllerDidSeletedTime:self.startCotent.text endTime:self.endContent.text];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showPopAlerViewWithMes:@"请选择时间" withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
    }
    
}
- (BOOL)labelhastext:(UILabel *)label
{
    return label.text && ![label.text isEqualToString:@""];
}
- (IBAction)tapGesture:(id)sender
{
    DLog();
    UIGestureRecognizer * tap = (UIGestureRecognizer *)sender;
    [self setSeletedView:[tap view] WithAnimation:YES];
}
- (void)setSeletedView:(UIView *)view WithAnimation:(BOOL)animation
{
    [self resetView];
    animation = !CGPointEqualToPoint(view.center, self.seletedBgView.center);
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.seletedBgView.center = view.center;
        } completion:^(BOOL finished) {
            [self setViewToselete:view];
            [self showDateTime:view];
        }];
    }else{
        self.seletedBgView.center = view.center;
        [self setViewToselete:view];
        [self showDateTime:view];
    }
}
- (void)resetView
{
    self.startTimeLabel.textColor = [UIColor blackColor];
    self.startCotent.textColor = BASEGREENCOLOR;
    self.endTimeLabel.textColor = [UIColor blackColor];
    self.endContent.textColor = BASEGREENCOLOR;
}

#pragma mark -
- (void)showDateTime:(UIView *)view
{
    ActionSheetDatePicker * actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:view];
    [actionSheetPicker showActionSheetPicker];
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    if (_isStartTime) {
        _preDate = selectedDate;
        self.startCotent.text = [self stringFromdate:selectedDate];
    }else{
        if (!_preDate) {
            [self showTotasViewWithMes:@"请先选择开始时间"];
            return;
        }
        if ([selectedDate timeIntervalSinceDate:_preDate] > 0 ) {
            self.endContent.text = [self stringFromdate:selectedDate];
        }else{
            [self showTotasViewWithMes:@"选取时间不对,请重新选择"];
        }
    }
}
- (NSString *)stringFromdate:(NSDate *)Adate
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:Adate];
}
- (void)setViewToselete:(UIView *)view
{
    switch (view.tag) {
        case 100:
            _isStartTime = YES;
            self.startTimeLabel.textColor = [UIColor whiteColor];
            self.startCotent.textColor = [UIColor whiteColor];
            break;
         case 101:
            _isStartTime = NO;
            self.endTimeLabel.textColor = [UIColor whiteColor];
            self.endContent.textColor = [UIColor whiteColor];
            break;
        default:
            break;
    }
}
@end
