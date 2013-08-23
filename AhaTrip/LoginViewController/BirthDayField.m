//
//  BirthDayField.m
//  AhaTrip
//
//  Created by sohu on 13-7-4.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "BirthDayField.h"
#import "ActionSheetDatePicker.h"

@implementation BirthDayField
@synthesize isGirl = _isGirl;
@synthesize g_Button = _g_Button;
@synthesize b_Button = _b_Button;
@synthesize textFiled = _textFiled;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addtextFiled];
        [self addButton];
        [self addGenderButtons];
        
    }
    return self;
}
- (void)setButtonNormalTextColor:(UIColor *)color seletedColor:(UIColor *)seletedColor
{
    _normalColor = color;
    _seletedColor = seletedColor;
//    [self setGenderButtonsState];
}
- (void)addtextFiled
{
    self.backgroundColor = [UIColor clearColor];
    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 147, 35)];
    _textFiled.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFiled.delegate = self;
    [self addSubview:_textFiled];
}
- (void)addButton
{
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(buttonDateClick:) forControlEvents:UIControlEventTouchUpInside];
    CGRect rect = _textFiled.bounds;
    //    rect.size.width = 147;
    _button.frame = rect;
    [self addSubview:_button];
}
- (void)addGenderButtons
{
    _b_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_b_Button setTitle:@"女" forState:UIControlStateNormal];
    _b_Button.tag = 100;
    _b_Button.titleLabel.font = [UIFont systemFontOfSize:15.f];
    _b_Button.frame = CGRectMake(173, 0, 40, 40);
    [_b_Button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_b_Button addTarget:self action:@selector(genderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_b_Button];
    
    _g_Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_g_Button setTitle:@"男" forState:UIControlStateNormal];
    _g_Button.titleLabel.font = [UIFont systemFontOfSize:15.f];
    _g_Button.frame = CGRectMake(220, 0, 40, 40);
    [_g_Button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
    [_g_Button addTarget:self action:@selector(genderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _g_Button.tag = 200;
    [self addSubview:_g_Button];
    
//    self.isGirl = YES;
    [self setButtonNormalTextColor:[UIColor whiteColor] seletedColor:[UIColor whiteColor]];
    //    [self setGenderButtonsState];
}
- (void)setIsGirl:(BOOL)isGirl
{
    _isGirl = isGirl;
    [self setGenderButtonsState];
}
- (void)genderButtonClick:(UIButton *)button
{
    if (button.tag == 100 && !self.isGirl){ //男
        self.isGirl = YES;
    }
    if (button.tag == 200 && self.isGirl) {
        self.isGirl = NO;
    }
    [self setGenderButtonsState];
}
- (void)setGenderButtonsState
{
    if (self.isGirl) {
        [_b_Button setBackgroundImage:[UIImage imageNamed:@"gender_button_bg.png"] forState:UIControlStateNormal];
        [_b_Button setTitleColor:_seletedColor forState:UIControlStateNormal];
        [_g_Button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_g_Button setTitleColor:_normalColor forState:UIControlStateNormal];
    }else{
        
        [_b_Button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_b_Button setTitleColor:_normalColor forState:UIControlStateNormal];
        
        [_g_Button setBackgroundImage:[UIImage imageNamed:@"gender_button_bg.png"] forState:UIControlStateNormal];
        [_g_Button setTitleColor:_seletedColor forState:UIControlStateNormal];
    }
}
- (void)buttonDateClick:(UIButton *)Abutton
{
    DLog();
    for (UIView * view in self.superview.subviews) {
        [view resignFirstResponder];
    }
    ActionSheetDatePicker * actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:Abutton];
    [actionSheetPicker showActionSheetPicker];
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    date = selectedDate;
    self.textFiled.text = [NSString stringWithFormat:@" 生日: %@",[self stringFromdate:selectedDate]];
}
- (NSString *)stringFromdate:(NSDate *)Adate
{
    //转化日期格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd"];
    return [dateFormatter stringFromDate:Adate];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}
- (NSString *)timeString
{
    return [self stringFromdate:date];
}
@end
