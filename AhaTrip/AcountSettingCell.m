//
//  AcountSettingCell.m
//  AhaTrip
//
//  Created by sohu on 13-7-4.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "AcountSettingCell.h"
#define OFFSET   5.f
#import "UIImageView+WebCache.h"

@class AcountSettingCell;
@implementation AcountSettingCellDataSource
@synthesize userName,userDes,birthday,sex;

+ (CGFloat)heigth
{
    return OFFSET + ( 300 - OFFSET * 2) + 42 * 3 + OFFSET;
}
- (NSDictionary*)userInfo
{
    return nil;
}
@end

@implementation AcountSettingCell
@synthesize portraitImage = _portraitImage;
@synthesize userNameLabel = _userNameLabel;
@synthesize userDes = _userDes;
@synthesize birthday = _birthday;
@synthesize dataSouce = _dataSouce;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView * view = [[UIImageView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addAllSubViews];
    }
    return self;
}
- (void)addAllSubViews
{
    [self addPortraitImage];
    [self addtextFields];
}
- (void)addPortraitImage
{
    _portraitImage = [[PortraitView alloc] initWithFrame:CGRectMake(OFFSET, OFFSET, 300 - OFFSET * 2, 300 - OFFSET * 2)];
    _portraitImage.backgroundColor  = [UIColor clearColor];
    [_portraitImage setUserInteractionEnabled:YES];
    [self.contentView addSubview:_portraitImage];
    UIButton * button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    [button setImage:[UIImage imageNamed:@"setting_changButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changePortraitImage:) forControlEvents:UIControlEventTouchUpInside];
    [_portraitImage addSubview:button];
    button.center = CGPointMake(_portraitImage.frame.size.width /2.f, _portraitImage.frame.size.height - 35/2.f - 5);

}
- (void)addtextFields
{
    _userNameLabel = [self addTextFieldWithReferenceView:_portraitImage placeHolder:@"昵称" returnKey:UIReturnKeyNext];
    _userDes  = [self addTextFieldWithReferenceView:_userNameLabel placeHolder:@"个人简介" returnKey:UIReturnKeyDone];
    _birthday = [self addBirthFieldWithReferenceView:_userDes placeHolder:@"生日" returnKey:UIReturnKeyNext];
}

- (UITextField *)addTextFieldWithReferenceView:(UIView *)view placeHolder:(NSString *)holder returnKey:(UIReturnKeyType)type
{
    UITextField *  field = [[UITextField alloc] initWithFrame:CGRectMake(OFFSET * 2, view.frame.origin.y + view.frame.size.height, _portraitImage.frame.size.width - OFFSET * 2, 42)];
    [self setTextFiledPorperty:field];
    field.placeholder = holder;
    field.returnKeyType = type;
    [self.contentView addSubview:field];
    UIImageView * lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settting_line.png"]];
    lineView.frame = CGRectMake(0, field.frame.size.height - 1 + field.frame.origin.y, self.frame.size.width, 1);
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:lineView];
    return field;
}
- (BirthDayField *)addBirthFieldWithReferenceView:(UIView *)view placeHolder:(NSString *)holder returnKey:(UIReturnKeyType)type
{
    BirthDayField *  field = [[BirthDayField alloc] initWithFrame:CGRectMake(OFFSET * 2, view.frame.origin.y + view.frame.size.height, view.frame.size.width - OFFSET * 4, 42)];
    [field setButtonNormalTextColor:[UIColor blackColor] seletedColor:[UIColor whiteColor]];
    [self setTextFiledPorperty:field.textFiled];
    field.textFiled.placeholder = holder;
    field.textFiled.returnKeyType = type;
    field.textFiled.center = CGPointMake(field.textFiled.center.x, field.textFiled.center.y + 5);
    [self.contentView addSubview:field];
    return field;
}
- (void)setTextFiledPorperty:(UITextField *)field
{
    field.font = [UIFont systemFontOfSize:15];
    field.textColor = [UIColor blackColor];
    field.backgroundColor = [UIColor clearColor];
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.delegate = self;
    [field addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)textFieldDidEndOnExit:(UITextField *)field
{
    if (field == _userNameLabel) {
        [_userDes becomeFirstResponder];
        [_userNameLabel resignFirstResponder];
    }
    if (field == _userDes) {
        [_userDes resignFirstResponder];
        [_userNameLabel resignFirstResponder];
        if ([_delegate respondsToSelector:@selector(acountSettingCellDidFinishedEdit:)])
            [_delegate acountSettingCellDidFinishedEdit:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(acountSettingCellDidBeginEdit:)])
        [_delegate acountSettingCellDidBeginEdit:self];
}
- (void)setDataSouce:(AcountSettingCellDataSource *)dataSouce
{
    if (_dataSouce != dataSouce) {
        _dataSouce = dataSouce;
        [self updataAllViews];
    }
}

- (void)updataAllViews
{
    [_portraitImage.imageView setImageWithURL:[NSURL URLWithString:_dataSouce.poraitImage] placeholderImage:[UIImage imageNamed:@"avatar_560.png"] options:SDWebImageRetryFailed success:^(UIImage *image) {
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
    _userNameLabel.text = _dataSouce.userName;
    _userDes.text = _dataSouce.userDes;
    _birthday.textFiled.text = [NSString stringWithFormat:@"生日:%@",_dataSouce.birthday];
//    if ([_dataSouce.sex isEqualToString:@"female"]) {
//        _birthday.isGirl = YES;
//    }else if ([_dataSouce.sex isEqualToString:@"male"]){
//        _birthday.isGirl = NO;
//    }
}

- (void)changePortraitImage:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(acountSettingCell:changeImage:)])
        [_delegate acountSettingCell:self changeImage:button];
}

@end
