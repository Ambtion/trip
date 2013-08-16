//
//  AVertCoastController.m
//  AhaTrip
//
//  Created by sohu on 13-8-16.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "AvertCoastController.h"

@interface AvertCoastController ()
{
    NSMutableArray * _dataSource;
    NSDictionary * _seletedInfo;
    ActionSheetCustomPicker * _picker;
}

@end

@implementation AvertCoastController
@synthesize delete;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    [self addTabBar];
    [self getUnits];
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
    [closeAll addTarget:self action:@selector(Afinished:) forControlEvents:UIControlEventTouchUpInside];
    [backimageView addSubview:closeAll];
}

- (void)closeBtnBackMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)Afinished:(UIButton *)button
{
    if (!self.coatNumberFiled.text || [self.coatNumberFiled.text isEqualToString:@""]) {
        [self showPopAlerViewWithMes:@"请填写价格" withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
        return;
    }
    if (!self.unitFiled.text || [self.unitFiled.text isEqualToString:@""]) {
        [self showPopAlerViewWithMes:@"请选择价格单位" withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
        return;
    }
    if ([delete respondsToSelector:@selector(avertCoastControllerDidSeletedPrice:uinit:)]) {
        [delete avertCoastControllerDidSeletedPrice:self.coatNumberFiled.text uinit:_seletedInfo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapGesture:(id)sender
{
    UIGestureRecognizer * ges  = (UIGestureRecognizer *)sender;
    _picker = [[ActionSheetCustomPicker alloc] initWithTitle:@"" delegate:self showCancelButton:NO origin:[ges view]];
    [_picker showActionSheetPicker];
}

- (IBAction)screenViewTap:(UITapGestureRecognizer *)sender
{
    [self.coatNumberFiled resignFirstResponder];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    return !CGRectContainsPoint(CGRectMake(10, 58, 300, 88), point) && !CGRectContainsPoint(CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 55 - 20, 320, 77), point);
}

- (void)getUnits
{
    [self waitForMomentsWithTitle:@"加载中" withView:self.view];
    [RequestManager getUintWithSuccess:^(NSString *response) {
        _dataSource = [[response JSONValue] objectForKey:@"units"];
        if (_dataSource.count)
            _seletedInfo = [_dataSource objectAtIndex:0];
        [self stopWaitProgressView:nil];
    } failure:^(NSString *error) {
        [self stopWaitProgressView:nil];
    }];
}
- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    DLog();
    UILabel * label = (UILabel*)origin;
    label.text = [_seletedInfo objectForKey:@"en_name"];
}
#pragma mark PickerDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataSource count];
}
- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSDictionary * dic = [_dataSource objectAtIndex:row];
    NSString * name = [dic objectForKey:@"name"];
    NSString * ename = [dic objectForKey:@"en_name"];
    UIImageView * finalView = nil;
    if (!view) {
        finalView = [self creteCellView];
    }else{
        finalView = (UIImageView *)view;
    }
    [self setBgView:finalView Text:name enText:ename];
    return finalView;
}
- (UIImageView*)creteCellView
{
  
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgView.image = [[UIImage imageNamed:@"rect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 150, 20, 150)];
    DetailTextView * dtView = [[DetailTextView alloc] initWithFrame:CGRectMake(15, 12, 200, 40)];
    dtView.backgroundColor = [UIColor clearColor];
    dtView.tag = 5000;
    [bgView addSubview:dtView];
    return bgView;
}
- (void)setBgView:(UIImageView*)view Text:(NSString *)text enText:(NSString *)entext
{
    DetailTextView * dtView = (DetailTextView *)[view viewWithTag:5000];
    NSString * str = [NSString stringWithFormat:@"%@ %@",text,entext];
    [dtView setText:str WithFont:[UIFont systemFontOfSize:18.f] AndColor:[UIColor blackColor]];
    [dtView setKeyWordTextArray:[NSArray arrayWithObjects:entext, nil] WithFont:[UIFont systemFontOfSize:12.f] AndColor:[UIColor blackColor]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _seletedInfo = [_dataSource objectAtIndex:row];
}

@end
