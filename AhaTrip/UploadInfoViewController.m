//
//  UploadInfoViewController.m
//  AhaTrip
//
//  Created by sohu on 13-8-12.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "UploadInfoViewController.h"


#define  PIC_WIDTH 70
#define  PIC_HEIGHT 70
#define  INSETS 10

#define kBtnRankNum 4
#define kBtnOriginX 4
#define kBtnOriginY 15
#define kBtnWidth   75
#define kBtnHeight  75
#define kIntevalX  4
#define kIntevalY  15

#define PLUSICON [UIImage imageNamed:@"plus_icon.png"]
#define DESC_COUNT_LIMIT 100

@interface UploadInfoViewController ()

@end

@implementation UploadInfoViewController
@synthesize delegate;
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithImageUrls:(NSMutableArray *)AimageArray
{
    if (self = [super init]) {
        _imagesArray = AimageArray;
        _locationName = @"添加当前位置";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor= [UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.f];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [self addScrollView];
    [self resetThumbnailImages];
    [self addTabBar];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)] ;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark Notification
- (void)keyboardDidShow:(NSNotification *)notification
{
    if (_myScrollView.contentOffset.y < 90)
        [_myScrollView setContentOffset:CGPointMake(0, 90) animated:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
        return NO;
    return YES;
}
- (void)handleGuesture:(UITapGestureRecognizer *)gesture
{
    [_desTextView resignFirstResponder];
}
#pragma mark AddSubViews
- (void)addScrollView
{
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 20.f;
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,height - 55)];
    _myScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_myScrollView];
}

- (void)resetThumbnailImages
{
    [_myScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < _imagesArray.count + 1; i++)
    {
        NSUInteger row = i / kBtnRankNum;
        NSUInteger rank = i % kBtnRankNum;
        CGRect rect = CGRectMake(kBtnOriginX + rank * (kBtnWidth + kIntevalX), kBtnOriginY + row * (kBtnHeight + kIntevalY), kBtnWidth, kBtnHeight);
        UIButton * imageBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
        imageBtn.frame = rect;
        [imageBtn addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == _imagesArray.count)
        {
            [imageBtn setTag:1000];
            [imageBtn setImage:PLUSICON forState:UIControlStateNormal];
        }else{
            [imageBtn setTag:i];
            [imageBtn setImage:[[_imagesArray objectAtIndex:i] objectForKey:@"Thumbnail"] forState:UIControlStateNormal];
//            [imageBtn setImage:[_imagesArray objectAtIndex:i] forState:UIControlStateNormal];
        }
        _offsetY = imageBtn.frame.origin.y+ imageBtn.frame.size.height + 15;
        [_myScrollView addSubview:imageBtn];
    }
    [self resetDesTextView];
    [self resetLocation];
    [self resetOptionalSeleted];
    [self addBindViews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetThumbnailImages];
}
-(void)resetDesTextView
{
    //  153
    if (!_desTextView) {
        _desTextView = [[UITextView alloc]initWithFrame:CGRectMake(10,_offsetY, 300, 100)];
        _desTextView.layer.borderColor = [[UIColor colorWithRed:153.f/255 green:153.f/255  blue:153.f/255  alpha:1.f] CGColor];
        _desTextView.layer.borderWidth = 1.0f;
        _desTextView.backgroundColor = [UIColor whiteColor];
        _desTextView.font = [UIFont fontWithName:@"Arial" size:15.0f];
        _desTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _desTextView.textAlignment = UITextAlignmentLeft;
        _desTextView.keyboardType = UIKeyboardTypeDefault;
        _desTextView.returnKeyType =UIReturnKeyDone;
        _desTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
        _desTextView.delegate = self;
        _placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
        _placeHolder.placeholder = @"我还有话要说的。。。。 😄";
        [_placeHolder setUserInteractionEnabled:NO];
        [_desTextView addSubview:_placeHolder];
        [_myScrollView addSubview: _desTextView];
    }else{
        _desTextView.frame = CGRectMake(10,_offsetY, 300, 100);
        [_myScrollView addSubview:_desTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [_desTextView resignFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > DESC_COUNT_LIMIT) ? NO : YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text && ![textView.text isEqualToString:@""]) {
        if (!_placeHolder.hidden)
            [_placeHolder setHidden:YES];
    }else{
        if (_placeHolder.hidden)
            [_placeHolder setHidden:NO];
    }
}

#pragma mark LocaionView
- (void)resetLocation
{
    if (!_locationView) {
        [self creteLocatonView];
    }else{
        _locationView.frame = CGRectMake(10,_desTextView.frame.size.height + _desTextView.frame.origin.y + 15, 300, 30);
        [_myScrollView addSubview:_locationView];
    }
    [self setLocationText:_locationName];
}
- (void)creteLocatonView
{
    _locationView = [[UIView alloc] initWithFrame:CGRectMake(10,_desTextView.frame.size.height + _desTextView.frame.origin.y + 15, 300, 30)];
    _locationView.backgroundColor = [UIColor colorWithRed:220.f/255.f green:220.f/255.f blue:220.f/255.f alpha:1.f];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _locationView.frame.size.height, _locationView.frame.size.height)];
    imageView.image  = [UIImage imageNamed:@"LocationIcon.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_locationView addSubview:imageView];
    UILabel * textLabel  = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, _locationView.frame.size.width -  40 - 10, _locationView.frame.size.height)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:14.f];
    textLabel.textColor = [UIColor colorWithRed:50.f/255 green:200/255.f blue:160.f/255 alpha:1.f];
    textLabel.tag = 1000;
    [_locationView addSubview:textLabel];
    
    UIImageView * arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(_locationView.frame.size.width - _locationView.frame.size.height, 0 , _locationView.frame.size.height, _locationView.frame.size.height)];
    arrowImage.backgroundColor = [UIColor clearColor];
    arrowImage.contentMode = UIViewContentModeScaleAspectFit;
    arrowImage.image = [UIImage imageNamed:@"arrow.png"];
    [_locationView addSubview:arrowImage];
    UIButton * button = [[UIButton alloc] initWithFrame:_locationView.bounds];
    [button addTarget:self action:@selector(locationGestureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_locationView addSubview:button];
    [_myScrollView addSubview:_locationView];
}

- (void)setLocationText:(NSString *)str
{
    UILabel * label = (UILabel *)[_locationView viewWithTag:1000];
    label.text = str;
    _locationName = str;
}

#pragma mark optional  des
- (UIImageView *)bgViewFromFile:(UITextField *)filed
{
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:filed.frame];
    bgView.image = [[UIImage imageNamed:@"input1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    return bgView;
}

- (void)resetOptionalSeleted
{
    if (!_optionalView) {
        _optionalView = [[UIView alloc] initWithFrame:CGRectMake(10, _locationView.frame.origin.y+ _locationView.frame.size.height+20, 300, 100)];
        _optionalView.backgroundColor=[UIColor clearColor];
        [_myScrollView addSubview:_optionalView];
        
        UILabel * slectLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 40, 30)];
        slectLabel.text=@"选填";
        slectLabel.backgroundColor=[UIColor clearColor];
        slectLabel.textColor=[UIColor blackColor];
        slectLabel.font=[UIFont systemFontOfSize:18.f];
        [_optionalView addSubview:slectLabel];
        
        UITextField* timeFild =[[UITextField alloc]initWithFrame:CGRectMake(40 + 10, 8, 250, 30)];
        timeFild.borderStyle =  UITextBorderStyleNone;
        timeFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        timeFild.backgroundColor = [UIColor clearColor];
        timeFild.font = [UIFont fontWithName:@"Arial" size:16.0f];
        timeFild.placeholder = @"营业时间";
        timeFild.textAlignment=UITextAlignmentCenter;
        [_optionalView addSubview:[self bgViewFromFile:timeFild]];
        [_optionalView addSubview:timeFild];
        UIButton * button = [[UIButton alloc] initWithFrame:timeFild.bounds];
        button.tag = 1;
        [button addTarget:self action:@selector(buttonDateClick:) forControlEvents:UIControlEventTouchUpInside];
        [timeFild addSubview:button];
        
        UITextField* avregeText=[[UITextField alloc]initWithFrame:CGRectMake(50, 43, 125, 30)];
        avregeText.borderStyle =  UITextBorderStyleNone;
        avregeText.backgroundColor=[UIColor clearColor];
        avregeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        avregeText.font = [UIFont fontWithName:@"Arial" size:16.0f];
        avregeText.textAlignment=UITextAlignmentCenter;
        avregeText.placeholder = @"人均消费";
        [_optionalView addSubview:[self bgViewFromFile:avregeText]];
        [_optionalView addSubview:avregeText];
        UIButton * button2 = [[UIButton alloc] initWithFrame:timeFild.bounds];
        button2.tag = 2;
        [button2 addTarget:self action:@selector(buttonDateClick:) forControlEvents:UIControlEventTouchUpInside];
        [avregeText addSubview:button2];
        
        UITextField * wifiText=[[UITextField alloc]initWithFrame:CGRectMake(175, 43, 125, 30)];
        wifiText.borderStyle =  UITextBorderStyleNone;
        wifiText.backgroundColor = [UIColor clearColor];
        wifiText.font = [UIFont fontWithName:@"Arial" size:16.0f];
        wifiText.textColor = [UIColor blackColor];
        wifiText.textAlignment=UITextAlignmentCenter;
        wifiText.clearButtonMode = UITextFieldViewModeAlways;
        
        //输入框中一开始就有的文字
        wifiText.placeholder = @"Wifi 有/无";
        wifiText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_optionalView addSubview:[self bgViewFromFile:wifiText]];
        [_optionalView addSubview:wifiText];
        UIButton * button3 = [[UIButton alloc] initWithFrame:timeFild.bounds];
        button3.tag = 3;
        [button3 addTarget:self action:@selector(buttonDateClick:) forControlEvents:UIControlEventTouchUpInside];
        [wifiText addSubview:button3];
    }else{
        [_myScrollView addSubview:_optionalView];
        _optionalView.frame = CGRectMake(10, _locationView.frame.origin.y+ _locationView.frame.size.height+20, 300, 100);
    }
}


#pragma mark Bind
-(void)addBindViews
{
    if (!_bindView) {
        _bindView=[[UIView alloc] initWithFrame:CGRectMake(10, _optionalView.frame.origin.y + _optionalView.frame.size.height+10, 300, 140)];
        _bindView.backgroundColor=[UIColor clearColor];
        [_myScrollView addSubview:_bindView];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,80,30)];
        label.text= @"分享到";
        label.textColor=[UIColor lightGrayColor];
        label.backgroundColor=[UIColor clearColor];
        [_bindView addSubview:label];
        
        UITableView * _bindTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 35, 300, 100)];
        _bindTableView.delegate=self;
        _bindTableView.dataSource=self;
        _bindTableView.scrollEnabled=NO;
        _bindTableView.backgroundColor=[UIColor whiteColor];
        [_bindView addSubview:_bindTableView];
        
        UIImage * imagesina = [UIImage imageNamed:@"sina.png"];
        UIImage * imagetencent = [UIImage imageNamed:@"tencent weibo.png"];
        NSString * sinastr = @"新浪微博";
        NSString * tencentStr = @"腾讯微博";
        NSDictionary*dict = [NSDictionary dictionaryWithObjectsAndKeys:imagesina,@"image",sinastr,@"sso", nil];
        NSDictionary* dict2 =[NSDictionary dictionaryWithObjectsAndKeys:imagetencent,@"image",tencentStr,@"sso", nil];
        _bindArray = [NSMutableArray arrayWithObjects:dict,dict2, nil];
        [_myScrollView addSubview:_bindView];
    }else{
        [_myScrollView addSubview:_bindView];
        _bindView.frame = CGRectMake(10, _optionalView.frame.origin.y + _optionalView.frame.size.height+10, 300, 100);
    }
    _myScrollView.contentSize = CGSizeMake(_myScrollView.frame.size.width, _bindView.frame.size.height + _bindView.frame.origin.y);
}

#pragma table delegate/datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *topicCell = @"TopicCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:topicCell];
    if(!cell)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;\
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 25)];
        imgV.tag = 100;
        imgV.backgroundColor=[UIColor clearColor];
        [cell addSubview:imgV];
        
        UILabel * ssolabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 2, 80, 45)];
        ssolabel.tag = 200;
        ssolabel.backgroundColor=[UIColor clearColor];
        [cell addSubview:ssolabel];
        
        UISwitch*sw=[[UISwitch alloc] init];
        sw.frame=CGRectMake(205,10,50,40);
        sw.tag = 300;
        [sw setOn:YES];
        [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:sw];
        
    }
    NSDictionary * dict=[_bindArray objectAtIndex:indexPath.row];
    UIImageView * imagv = (UIImageView *)[cell viewWithTag:100];
    imagv.image = [dict objectForKey:@"image"];
    UILabel * label = (UILabel *)[cell viewWithTag:200];
    label.text = [dict objectForKey:@"sso"];
    UISwitch * sw = (UISwitch *)[cell viewWithTag:300];
    [sw setOn:YES];
    return cell;
}

#pragma mark - AddTabBar
-(void)addTabBar
{
    //    底部导航
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 20;
    UIView * bottomBar=[[UIView alloc] initWithFrame:CGRectMake(0, height - 55,320, 55)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    //    返回menu页的按钮
    UIButton *closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10,0, 50, 55)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBack) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:closeMenuBtn];
    //send的按钮
    UIButton * sendeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendeBtn setFrame:CGRectMake(250, 0 , 50, 55)];
    sendeBtn.contentMode=UIViewContentModeScaleAspectFit;
    [sendeBtn setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [sendeBtn addTarget:self action:@selector(uploadImageView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:sendeBtn];
}
- (void)closeBtnBack
{
    [_imagesArray removeAllObjects];
    _locationName = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Action
- (void)imageButtonClick:(UIButton *)button
{
    if (button.tag==1000){
        if ([delegate respondsToSelector:@selector(uploadInfoViewControllerDidClickAddPic:)]) {
            [delegate uploadInfoViewControllerDidClickAddPic:button];
        }
    }else{
        if (_imagesArray.count > button.tag){
            [_imagesArray removeObjectAtIndex:button.tag];
            [self resetThumbnailImages];
        }
    }
    
}

- (void)locationGestureClick:(UIButton *)button
{
    DLog(@"");
    if ([delegate respondsToSelector:@selector(uploadInfoViewControllerDidClickAddLocation:)])
        [delegate uploadInfoViewControllerDidClickAddLocation:button];
}

- (void)buttonDateClick:(UIButton *)button
{
    if (button.tag == 1) {
        //营业时间
        ActionSheetDatePicker * actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date] target:self action:@selector(dateWasSelected:element:) origin:button];
        [actionSheetPicker showActionSheetPicker];
    }else if(button.tag == 2){
        
    }else{
        
    }
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element
{
    DLog();
}

- (void)uploadImageView:(UIButton *)button
{
    if ([delegate respondsToSelector:@selector(uploadInfoViewControllerDidClickSender:)])
        [delegate uploadInfoViewControllerDidClickSender:[self getOptionalAndDesInfo]];
}
- (NSDictionary *)getOptionalAndDesInfo
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:@YES forKey:@"WiFi"];
    [dic setObject:@"100元" forKey:@"Avert"];
    [dic setObject:@"10:20-11:20" forKey:@"Time"];
    [dic setObject:@"sdf我不sd" forKey:@"Des"];
    return dic;
}
- (void)switchAction:(id)sender
{
    UISwitch * switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [switchButton setOn:YES animated:YES];
    }else {
        [switchButton setOn:NO animated:NO];
    }
}
@end

