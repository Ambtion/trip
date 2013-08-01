//
//  PersonalViewController.m
//  XQSearchPlaces
//
//  Created by xuwenjuan on 13-6-26.
//  Copyright (c) 2013年 iObitLXF. All rights reserved.
//

#import "PersonalViewController.h"
#import "ButtonView.h"
#import "GPUImage.h"
#import "BlurOverlayView.h"
#import "DeleteViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Constants.h"   
#define  PIC_WIDTH 70
#define  PIC_HEIGHT 70
#define  INSETS 10

#define kBtnRankNum 4
#define kBtnOriginX 4
#define kBtnOriginY 20
#define kBtnWidth   75
#define kBtnHeight  75
#define kIntevalX  4
#define kIntevalY  4

@interface PersonalViewController ()
<   UIActionSheetDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@end

@implementation PersonalViewController
@synthesize placeName,longtitude,latitude;
@synthesize photoArr;
@synthesize photoImage;

-(void)addADDFiled{
//  153
    addFild=[[UITextField alloc]initWithFrame:CGRectMake(10,rectY, 300, 100)];
    addFild.borderStyle =  UITextBorderStyleNone;
    CALayer *layer = [nameFild layer];
    layer.borderColor = [mRGBColor(153, 153, 153)CGColor];
    layer.borderWidth = 10.0f;

    addFild.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
    addFild.backgroundColor = [UIColor whiteColor];
    
    //设置输入框内容的字体样式和大小
     addFild.font = [UIFont fontWithName:@"Arial" size:20.0f];
    
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
     addFild.clearButtonMode = UITextFieldViewModeAlways;
    
    //输入框中一开始就有的文字
     addFild.text = @"我还有话要说的。。。。";
    addFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
      //是否纠错
    addFild.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //再次编辑就清空
     addFild.clearsOnBeginEditing = YES;
    
    //内容对齐方式
     addFild.textAlignment = UITextAlignmentLeft;
    
    //内容的垂直对齐方式  UITextField继承自UIControl,此类中有一个属性contentVerticalAlignment
     addFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
    addFild.adjustsFontSizeToFitWidth = YES;
        //设置键盘的样式
     addFild.keyboardType = UIKeyboardTypeDefault;
    //return键变成什么键
     addFild.returnKeyType =UIReturnKeyDone;
    //键盘外观
     addFild.keyboardAppearance=UIKeyboardAppearanceDefault;
     addFild.delegate = self;
       UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smail.png"]];
       addFild.rightView=image;
        addFild.rightViewMode = UITextFieldViewModeAlways;
    
    [backScroll addSubview: addFild];





}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=mRGBColor(236, 235, 235);
}
-(void)closeBtnBack{

    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void) imagePickerControllerDidCancel:(DLCImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)buttonClicked:(UIButton*)sender
{
    if (sender.tag==1000)
    {
        if (self.photoArr.count<7) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
       
        }
        else {
           [sender removeFromSuperview];
        
        }
    }
    else
    {
        [photoArr removeObjectAtIndex:sender.tag];
        NSLog(@"%d",photoArr.count);
        [self reLayoutSubViews];

    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     [UIApplication sharedApplication].statusBarHidden = NO;
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType]; 
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    NSInteger index = self.photoArr.count - 1;
    [self.photoArr insertObject:image atIndex:index];
       [self reLayoutSubViews];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)reLayoutSubViews
{
    NSLog(@"%d",photoArr.count);
    if ([self isIphone5]) {
        height=548;
    }else{
        height=460;
    }
    backScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,height-44)];
    backScroll.delegate=self;
    backScroll.backgroundColor=[UIColor clearColor];
    backScroll.contentSize=CGSizeMake(320, height+100);
//    [self.view addSubview:backScroll];
    
       for (ButtonView *view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger rank = 0;
    for (int i = 0; i <photoArr.count; i++)
    {
        NSUInteger row = floor(i / kBtnRankNum);
        CGRect rect = CGRectMake(kBtnOriginX + rank * (kBtnWidth + kIntevalX), kBtnOriginY + row * (kBtnHeight + kIntevalY), kBtnWidth, kBtnHeight);
        
        rank++;
        if (rank == kBtnRankNum)
        {
            rank = 0;
        }
        
        ButtonView *btnView   = [[ButtonView alloc] initWithFrame:rect];
        [btnView.btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnView.btn setTag:i];
        
        if (i==photoArr.count-1)
        {
            [btnView.btn setTag:1000];
        }
       
        
        [btnView.btn setImage:[self.photoArr objectAtIndex:i] forState:UIControlStateNormal];
        
      [backScroll addSubview:btnView];
        rectY=btnView.frame.origin.y+btnView.frame.size.height+15;
//        rectY=50;
        NSLog(@"%d",rectY);
      }
    if ([self isIphone5]) {
        height=548;
    }else{
        height=460;
    }

    [self.view addSubview:backScroll];

//    加载底部所有按钮的按钮
    [self addAllNAV];
//    [self addNameFild];
    [self addADDFiled];
//  选填  
    [self addSelect];
//分享到
    [self addShareUI];
   
}
-(void)addShareUI{
  
    
    
    UIImageView*backShareView=[[UIImageView alloc] initWithFrame:CGRectMake(10, selectBackView.frame.origin.y+selectBackView.frame.size.height+10, 300, 100)];
    backShareView.backgroundColor=[UIColor clearColor];
    [backScroll addSubview:backShareView];
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, 5,80,30)];
    label.text=@"分享到";
    label.textColor=[UIColor lightGrayColor];
    label.backgroundColor=[UIColor clearColor];
    [backShareView addSubview:label];
    
    
    shareTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 35, 300, 100)];
    shareTable.delegate=self;
    shareTable.dataSource=self;
    shareTable.scrollEnabled=NO;
    shareTable.backgroundColor=[UIColor whiteColor];
    [backShareView addSubview:shareTable];
   
    UIImage*imagesina=[UIImage imageNamed:@"sina.png"];
    UIImage*imagetencent=[UIImage imageNamed:@"tencent weibo.png"];
    NSString*sinastr=@"新浪微博";
    NSString*tencentStr=@"腾讯微博";
   
    NSDictionary*dict   = [NSDictionary dictionaryWithObjectsAndKeys:imagesina,@"image",sinastr,@"sso", nil];
    
    NSDictionary*dict2=[NSDictionary dictionaryWithObjectsAndKeys:imagetencent,@"image",tencentStr,@"sso", nil];
    shareArr=[NSMutableArray arrayWithObjects:dict,dict2, nil];

}

-(void)addSelect{
    selectBackView=[[UIView alloc] initWithFrame:CGRectMake(10, addFild.frame.origin.y+addFild.frame.size.height+15, 300, 100)];
    selectBackView.backgroundColor=[UIColor clearColor];
    [backScroll addSubview:selectBackView];
    
    UILabel*slectLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 40, 30)];
    slectLabel.text=@"选填";
    slectLabel.backgroundColor=[UIColor clearColor];
    slectLabel.textColor=[UIColor blackColor];
    slectLabel.font=[UIFont systemFontOfSize:18.f];
    [selectBackView addSubview:slectLabel];
    
    UITextField*timeFild=[[UITextField alloc]initWithFrame:CGRectMake(40, 8, 260, 30)];
   timeFild.borderStyle =  UITextBorderStyleNone;
//    CALayer *layer = [timeFild layer];
//    layer.borderColor = [mRGBColor(153, 153, 153)CGColor];
//    layer.borderWidth = 3.0f;
    timeFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

    timeFild.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input2.png"]];
   timeFild.font = [UIFont fontWithName:@"Arial" size:16.0f];
    
    //设置字体颜色
//    timeFild.textColor = [UIColor blackColor];
    
    timeFild.clearButtonMode = UITextFieldViewModeAlways;
    
    //输入框中一开始就有的文字
    timeFild.placeholder = @"营业时间";
    timeFild.textAlignment=UITextAlignmentCenter;
  timeFild.clearsOnBeginEditing = YES;
    
    timeFild.delegate = self;
    [selectBackView addSubview:timeFild];
    
    
 
    UITextField*avregeText=[[UITextField alloc]initWithFrame:CGRectMake(40, 43, 130, 30)];
   avregeText.borderStyle =  UITextBorderStyleNone;
    avregeText.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"input1.png"]];
   avregeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

//    CALayer *avregeTextlayer = [avregeText layer];
//   avregeTextlayer.borderColor = [mRGBColor(153, 153, 153)CGColor];
//   avregeTextlayer.borderWidth = 3.0f;
//    
//    avregeText.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    
//    avregeText.backgroundColor = [UIColor whiteColor];
    avregeText.font = [UIFont fontWithName:@"Arial" size:16.0f];
    avregeText.textAlignment=UITextAlignmentCenter;
    
    //设置字体颜色
//  avregeText.textColor = [UIColor blackColor];
    
  avregeText.clearButtonMode = UITextFieldViewModeAlways;
    
    //输入框中一开始就有的文字
   avregeText.placeholder = @"人均消费";
    
   
    
    //再次编辑就清空
   avregeText.clearsOnBeginEditing = YES;
    
    avregeText.delegate = self;
    [selectBackView addSubview:avregeText];
    
    
    UITextField*wifiText=[[UITextField alloc]initWithFrame:CGRectMake(170, 43, 130, 30)];
   wifiText.borderStyle =  UITextBorderStyleNone;
    
//    CALayer *wifiTextlayer = [wifiText layer];
//    wifiTextlayer.borderColor = [mRGBColor(153, 153, 153)CGColor];
//    wifiTextlayer.borderWidth = 3.0f;
    
    //    avregeText.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    
    wifiText.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input1.png"]];
   wifiText.font = [UIFont fontWithName:@"Arial" size:16.0f];
    
    //设置字体颜色
    wifiText.textColor = [UIColor blackColor];
    wifiText.textAlignment=UITextAlignmentCenter;
    wifiText.clearButtonMode = UITextFieldViewModeAlways;
    
    //输入框中一开始就有的文字
    wifiText.placeholder = @"Wifi 有/无";
     wifiText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    timeFild.autocorrectionType = UITextAutocorrectionTypeNo;
    
    //再次编辑就清空
   wifiText.clearsOnBeginEditing = YES;
    
    wifiText.delegate = self;
    [selectBackView addSubview:wifiText];


}

-(void)addAllNAV{
    //    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0,height-55,320, 55)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10,height-43, 50, 44)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
    //        send的按钮
    UIButton*sendeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendeBtn setFrame:CGRectMake(250, self.view.frame.size.height-40, 60, 30)];
    sendeBtn.contentMode=UIViewContentModeScaleAspectFit;
    [sendeBtn setImage:[UIImage imageNamed:@"send.png"] forState:UIControlStateNormal];
    [sendeBtn addTarget:self action:@selector(senderBTn) forControlEvents:UIControlEventTouchUpInside];
   [self.view addSubview:sendeBtn];



}
- (id)initWithLatitude:(NSString *)latitudeV longitude:(NSString*)longitudeV placeName:(NSString*)placeNameV image:(UIImage*)imageV singleCityId:(NSString*)singleCityId singleCityName:(NSString*)singleCityName cateryStr:(NSString*)cateryStr
{
    self = [super init];
    if (self)
        
        
    {
        //        NSString*str=latitudeV;
        
               NSLog(@"%@%@%@%@%@",longitudeV,latitudeV,singleCityName,singleCityId,cateryStr);
        
        photoImage=[UIImage imageNamed:@"plus_icon.png"];
        
        self.photoArr = [NSMutableArray array];
       [self.photoArr addObject:photoImage];
        
        [self.photoArr insertObject:imageV atIndex:0];
       [self reLayoutSubViews];
        

    }
    return self;
}
-(void)senderBTn{

//    [photoArr removeObjectAtIndex:0];
    NSLog(@"%d",photoArr.count);
//    [self reLayoutSubViews];


}
#pragma delegate;
- (void)PersonalViewControllerDidCancel:(PersonalViewController*)personal{

[self dismissViewControllerAnimated:YES completion:nil];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

//委托方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    
    return YES;
}

 

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
      return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;

}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
   }
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSRange range;
    range.location = 0;
    range.length = 0;
//    textField.selectedTextRange=range;

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
        NSDictionary*dict=[shareArr objectAtIndex:indexPath.row];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicCell];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView*imgV=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 25)];
        imgV.image=[dict objectForKey:@"image"];
        imgV.backgroundColor=[UIColor clearColor];
        [cell addSubview:imgV];
        
        
        UILabel*ssolabel=[[UILabel alloc] initWithFrame:CGRectMake(65, 2, 80, 45)];
        ssolabel.text=[dict objectForKey:@"sso"];
        ssolabel.backgroundColor=[UIColor clearColor];
        [cell addSubview:ssolabel];
        
        if (indexPath.row==0) {
            UISwitch*sw=[[UISwitch alloc] init];
            sw.frame=CGRectMake(205,10,50,40);
            [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
             [sw setOn:YES];
                       [cell addSubview:sw];

        }
        else{
            UISwitch*sw1=[[UISwitch alloc] init];
            sw1.frame=CGRectMake(205,10,50,40);
            [sw1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [sw1 setOn:YES];
            [cell addSubview:sw1];
        }
                      
    }
    return cell;
}
-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        [switchButton setOn:YES animated:YES];
    }else {
        [switchButton setOn:NO animated:NO];
    }


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   


}

@end
