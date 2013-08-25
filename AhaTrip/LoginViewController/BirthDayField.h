//
//  BirthDayField.h
//  AhaTrip
//
//  Created by sohu on 13-7-4.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetPicker.h"

@interface BirthDayField : UIView<UITextFieldDelegate>
{
    UITextField * _textFiled;
    UIButton * _button;
    UIButton * _g_Button;
    UIButton * _b_Button;
    UIColor * _normalColor;
    UIColor * _seletedColor;
    BOOL _isGirl;
    NSDate * date;
}
@property(nonatomic,assign)BOOL isGirl;
@property(nonatomic,strong)UITextField * textFiled;
@property(nonatomic,strong)UIButton * b_Button;
@property(nonatomic,strong)UIButton * g_Button;
- (id)initWithFrame:(CGRect)frame;
- (void)setButtonNormalTextColor:(UIColor *)color seletedColor:(UIColor *)seletedColor;
- (NSString *)timeString;
@end
