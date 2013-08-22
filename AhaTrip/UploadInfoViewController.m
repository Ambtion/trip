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
#define kBtnOriginX 10
#define kBtnOriginY 10
#define kBtnWidth   70
#define kBtnHeight  70
#define kIntevalX  7
#define kIntevalY  15

#define PLUSICON [UIImage imageNamed:@"plus_icon.png"]
#define DESC_COUNT_LIMIT 140

#define TIMEBGVIEWTAG  20000
#define AVERCOAST      20001
#define HASWIFI        20002

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
    if (_myScrollView.contentOffset.y < 60)
        [_myScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
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
            if ([[_imagesArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                [imageBtn setImage:[[_imagesArray objectAtIndex:i] objectForKey:@"Thumbnail"] forState:UIControlStateNormal];
            }else{
                [imageBtn setImage:[_imagesArray objectAtIndex:i] forState:UIControlStateNormal];
            }
        }
        _offsetY = imageBtn.frame.origin.y+ imageBtn.frame.size.height + 15;
        [_myScrollView addSubview:imageBtn];
    }
    [self resetDesTextView];
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
        _desTextView = [[UITextView alloc]initWithFrame:CGRectMake(kBtnOriginX ,_offsetY, 300, 60)];
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
        _placeHolder.placeholder = @"我还有话要说的...";
        [_placeHolder setUserInteractionEnabled:NO];
        [_desTextView addSubview:_placeHolder];
        [_myScrollView addSubview: _desTextView];
    }else{
        _desTextView.frame = CGRectMake(kBtnOriginX,_offsetY, 300, 60);
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

- (void)creteLocatonView
{
    _locationView = [[UIImageView alloc] initWithFrame:CGRectMake(0,30, 300, 44)];
    _locationView.image = [UIImage imageNamed:@"rect.png"];
    _locationView.backgroundColor = [UIColor clearColor];
    [_locationView setUserInteractionEnabled:YES];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _locationView.frame.size.height, _locationView.frame.size.height)];
    imageView.image  = [UIImage imageNamed:@"icon_location.png"];
    imageView.contentMode = UIViewContentModeCenter;
    [_locationView addSubview:imageView];
    
    UILabel * textLabel  = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, _locationView.frame.size.width -  40 - 10, _locationView.frame.size.height)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont boldSystemFontOfSize:16.f];
    textLabel.textColor = [UIColor blackColor];
    textLabel.tag = 1000;
    [_locationView addSubview:textLabel];
    UIImageView * arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(_locationView.frame.size.width + 10 - _locationView.frame.size.height, 0 , 26, 16)];
    arrowImage.center = CGPointMake(arrowImage.center.x, _locationView.frame.size.height /2.f);
    arrowImage.backgroundColor = [UIColor clearColor];
    arrowImage.image = [UIImage imageNamed:@"leftArrow.png"];
    arrowImage.contentMode = UIViewContentModeCenter;
    [_locationView addSubview:arrowImage];
    UIButton * button = [[UIButton alloc] initWithFrame:_locationView.bounds];
    [button addTarget:self action:@selector(locationGestureClick:) forControlEvents:UIControlEventTouchUpInside];
    [_locationView addSubview:button];
}

- (void)setLocationText:(NSString *)str
{
    UILabel * label = (UILabel *)[_locationView viewWithTag:1000];
    if (![str isEqualToString:@"添加当前位置"]) {
        label.textColor = [UIColor colorWithRed:50.f/255 green:200.f/255 blue:160.f/255 alpha:1];
    }else{
        label.textColor = [UIColor blackColor];
    }
    label.text = str;
    _locationName = str;
}

- (void)resetOptionalSeleted
{
    if (!_optionalView) {
        
        _optionalView = [[UIView alloc] initWithFrame:CGRectMake(kBtnOriginX, _desTextView.frame.origin.y + _desTextView.frame.size.height + 15, 300, 206)];
        _optionalView.backgroundColor=[UIColor clearColor];
        [_myScrollView addSubview:_optionalView];
        UILabel * slectLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 28)];
        slectLabel.text=@"等多(选填)";
        slectLabel.backgroundColor=[UIColor clearColor];
        slectLabel.textColor=[UIColor lightGrayColor];
        [_optionalView addSubview:slectLabel];
        
        [self creteLocatonView];
        [self setLocationText:_locationName];
        [_optionalView addSubview:_locationView];
        
        UIImageView * timeView = [self getLabelWithIcon:[UIImage imageNamed:@"icon_time.png"] tag:TIMEBGVIEWTAG title:@"营业时间"];
        timeView.frame = CGRectMake(0, _locationView.frame.size.height + _locationView.frame.origin.y, _locationView.frame.size.width, _locationView.frame.size.height);
        [_optionalView addSubview:timeView];
        
        UIImageView * averCost = [self getLabelWithIcon:[UIImage imageNamed:@"icon_dollar.png"] tag:AVERCOAST title:@"人均消费"];
        averCost.frame = CGRectMake(0, timeView.frame.size.height + timeView.frame.origin.y, timeView.frame.size.width, timeView.frame.size.height);
        [_optionalView addSubview:averCost];
        
        UIImageView * wifi = [self getLabelWithIcon:[UIImage imageNamed:@"icon_wifi.png"] tag:HASWIFI title:@"WIFI"];
        wifi.frame = CGRectMake(0, averCost.frame.size.height + averCost.frame.origin.y, averCost.frame.size.width, averCost.frame.size.height);
        [_optionalView addSubview:wifi];
        UIImageView * imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, wifi.frame.size.height + wifi.frame.origin.y - 1, 300, 1)];
        imag.image = [UIImage imageNamed:@"line.png"];
        [_optionalView addSubview:imag];
        
    }else{
        [_myScrollView addSubview:_optionalView];
        _optionalView.frame = CGRectMake(kBtnOriginX, _desTextView.frame.origin.y + _desTextView.frame.size.height + 15, 300, 206);
    }
}
- (UIImageView *)getLabelWithIcon:(UIImage *)image tag:(NSInteger)tag title:(NSString *)title
{
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,30, 300, 44)];
    bgView.image = [UIImage imageNamed:@"rect.png"];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.tag = tag;
    [bgView setUserInteractionEnabled:YES];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.height, bgView.frame.size.height)];
    imageView.image  = image;
    imageView.contentMode = UIViewContentModeCenter;
    [bgView addSubview:imageView];
    UILabel * textLabel  = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, bgView.frame.size.height)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont boldSystemFontOfSize:16.f];
    textLabel.text = title;
    textLabel.textColor = [UIColor blackColor];
    [bgView addSubview:textLabel];
    
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150, 44)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.font = [UIFont systemFontOfSize:13.f];
    contentLabel.textAlignment = UITextAlignmentRight;
    contentLabel.tag = 1000;
    contentLabel.textColor = [UIColor colorWithRed:50.f/255 green:200.f/255 blue:160.f/255 alpha:1];
    [bgView addSubview:contentLabel];
    
    UIImageView * arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width - bgView.frame.size.height + 10, 0 , 26, 16)];
    arrowImage.center = CGPointMake(arrowImage.center.x, bgView.frame.size.height /2.f);
    arrowImage.backgroundColor = [UIColor clearColor];
    arrowImage.image = [UIImage imageNamed:@"leftArrow.png"];
    arrowImage.contentMode = UIViewContentModeCenter;
    [bgView addSubview:arrowImage];
    UIButton * button = [[UIButton alloc] initWithFrame:_locationView.bounds];
    [button addTarget:self action:@selector(seletedOptionalClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button];
    return bgView;
}

- (void)setView:(UIImageView *)imageView WithText:(NSString *)str
{
    UILabel * label = (UILabel *)[imageView viewWithTag:1000];
    label.text = str;
    _locationName = str;
}
#pragma mark Bind
-(void)addBindViews
{
    if (!_bindView) {
        _bindView=[[UIView alloc] initWithFrame:CGRectMake(10, _optionalView.frame.origin.y + _optionalView.frame.size.height + 10, 300, 140)];
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
        _bindView.frame = CGRectMake(10, _optionalView.frame.origin.y + _optionalView.frame.size.height + 10, 300, 140);
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
    sendeBtn.contentMode=UIViewContentModeCenter;
    [sendeBtn setImage:[UIImage imageNamed:@"button_sent.png"] forState:UIControlStateNormal];
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
- (void)seletedOptionalClick:(UIButton *)button
{
    NSInteger tag = button.superview.tag;
    if (tag == TIMEBGVIEWTAG) {
        BusinessTimeController * bus = [[BusinessTimeController alloc] init];
        bus.delegate = self;
        [self.navigationController pushViewController:bus  animated:YES];
    }else if (tag == AVERCOAST ){
        AvertCoastController * cos = [[AvertCoastController alloc] initWithNibName:@"AVertCoastController" bundle:nil];
        cos.delete = self;
        [self.navigationController pushViewController:cos animated:YES];
    }else{
        HasWiFiController * wifi = [[HasWiFiController alloc] init];
        wifi.delegate = self;
        [self.navigationController pushViewController:wifi animated:YES];
    }
}

#pragma mark OptionalDelegate
- (void)businessTimeControllerDidSeletedTime:(NSString *)startTime endTime:(NSString *)endTime
{
    UIImageView * view = (UIImageView *)[self.view viewWithTag:TIMEBGVIEWTAG];
    [self setView:view WithText:[NSString stringWithFormat:@"%@-%@",startTime,endTime]];
}
- (void)avertCoastControllerDidSeletedPrice:(NSString *)price uinit:(NSDictionary *)info
{
    DLog(@"");
    UIImageView * view = (UIImageView *)[self.view viewWithTag:AVERCOAST];
    [self setView:view WithText:[NSString stringWithFormat:@"%@ %@",price, [info objectForKey:@"en_name"]]];
}
- (void)wifiControllerDidSeletedWithIndexTag:(NSInteger)tag
{
    UIImageView * view = (UIImageView *)[self.view viewWithTag:HASWIFI];
    NSString * str = nil;
    switch (tag) {
        case -1:
            str = @"";
            break;
        case 0:
            str = @"有";
            break;
        case 1:
            str = @"无";
            break;
        default:
            break;
    }
    [self setView:view WithText:str];
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

