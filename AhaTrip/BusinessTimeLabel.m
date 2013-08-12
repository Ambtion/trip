//
//  BusinessTimeLabel.m
//  AhaTrip
//
//  Created by sohu on 13-8-12.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "BusinessTimeLabel.h"

@implementation BusinessTimeLabel
@synthesize timeFild;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        timeFild =[[UITextField alloc]initWithFrame:CGRectMake(40 + 10, 8, 250, 30)];
        timeFild.borderStyle =  UITextBorderStyleNone;
        timeFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        timeFild.backgroundColor = [UIColor clearColor];
        timeFild.font = [UIFont fontWithName:@"Arial" size:16.0f];
        timeFild.placeholder = @"营业时间";
        timeFild.textAlignment=UITextAlignmentCenter;
        [self addSubview:[self bgViewFromFile:timeFild]];
        [self addSubview:timeFild];
        UIButton * button = [[UIButton alloc] initWithFrame:timeFild.bounds];
        button.tag = 1;
        [button addTarget:self action:@selector(buttonDateClick:) forControlEvents:UIControlEventTouchUpInside];
        [timeFild addSubview:button];

    }
    return self;
}
- (UIImageView *)bgViewFromFile:(UITextField *)filed
{
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:filed.frame];
    bgView.image = [[UIImage imageNamed:@"input1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    return bgView;
}

- (void)buttonDateClick:(UIButton *)button
{
    //营业时间
    ActionSheetDatePicker * actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:button];
    [actionSheetPicker showActionSheetPicker];
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    timeFild.text = [self stringFromdate:selectedDate];
}
- (NSString *)stringFromdate:(NSDate *)Adate
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    return [dateFormatter stringFromDate:Adate];
}
@end
