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
#define kBtnOriginY 4
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
//@synthesize singleCityName,singleCityId,cateryStr;
//-(void)addNameFild{
//    nameFild=[[UITextField alloc]initWithFrame:CGRectMake(10, rectY, 300, 50)];
//    nameFild.borderStyle = UITextBorderStyleRoundedRect;
//    
//    
//    //设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉
//    nameFild.backgroundColor = [UIColor whiteColor];
//    //设置背景
//    //    text.background = [UIImage imageNamed:@"dd.png"];
//    
//    //设置背景
//    nameFild.disabledBackground = [UIImage imageNamed:@"cc.png"];
//    //当输入框没有内容时，水印提示 提示内容为password
////    nameFild.placeholder = @"password";
//    
//    //设置输入框内容的字体样式和大小
//    nameFild.font = [UIFont fontWithName:@"Arial" size:20.0f];
//        //设置字体颜色
//    nameFild.textColor = [UIColor redColor];
//    
//    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
//    nameFild.clearButtonMode = UITextFieldViewModeAlways;
//    
//    //输入框中一开始就有的文字
//    nameFild.text = @"名称";
//    
//    //    //每输入一个字符就变成点 用语密码输入
//    //  nameFild.secureTextEntry = YES;
//    //
//    //是否纠错
//    nameFild.autocorrectionType = UITextAutocorrectionTypeNo;
//    
//    //再次编辑就清空
//    nameFild.clearsOnBeginEditing = YES;
//    
//    //内容对齐方式
//    nameFild.textAlignment = UITextAlignmentLeft;
//    
//    //内容的垂直对齐方式  UITextField继承自UIControl,此类中有一个属性contentVerticalAlignment
//    nameFild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    
//    //设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动
//    nameFild.adjustsFontSizeToFitWidth = YES;
//    
//    //设置自动缩小显示的最小字体大小
//    nameFild.minimumFontSize = 20;
//    nameFild.textColor=[UIColor lightGrayColor];
//    
//    //设置键盘的样式
//    nameFild.keyboardType = UIKeyboardTypeDefault;
//    //return键变成什么键
//    nameFild.returnKeyType =UIReturnKeyDone;
//    //键盘外观
//    nameFild.keyboardAppearance=UIKeyboardAppearanceDefault;
//    
//    //设置代理 用于实现协议
//    nameFild.delegate = self;
//    [self.view addSubview:nameFild];
//    //
//    //    //最右侧加图片是以下代码　 左侧类似
//    //    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
//    //    text.rightView=image;
//    //    text.rightViewMode = UITextFieldViewModeAlways;
//    
//    
//
//
//}
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
    //设置背景
//        addFild.background = [UIImage imageNamed:@"1.jpg"];
    
    //设置背景
   addFild.disabledBackground = [UIImage imageNamed:@"1.jpg"];
    //当输入框没有内容时，水印提示 提示内容为password
    //    nameFild.placeholder = @"password";
    
    //设置输入框内容的字体样式和大小
     addFild.font = [UIFont fontWithName:@"Arial" size:20.0f];
    
    //设置字体颜色
     addFild.textColor = [UIColor redColor];
    
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
     addFild.clearButtonMode = UITextFieldViewModeAlways;
    
    //输入框中一开始就有的文字
     addFild.text = @"我还有话要说的。。。。";
    
    //    //每输入一个字符就变成点 用语密码输入
    //  nameFild.secureTextEntry = YES;
    //
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
    
    //设置自动缩小显示的最小字体大小
    addFild.minimumFontSize = 20;
    addFild.textColor=[UIColor lightGrayColor];
    
    //设置键盘的样式
     addFild.keyboardType = UIKeyboardTypeDefault;
    //return键变成什么键
     addFild.returnKeyType =UIReturnKeyDone;
    //键盘外观
     addFild.keyboardAppearance=UIKeyboardAppearanceDefault;
//    addFild.selectedTextRange=(2, addFild.text.length);
    //设置代理 用于实现协议
     addFild.delegate = self;
    
    //
    //    //最右侧加图片是以下代码　 左侧类似
       UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
       addFild.rightView=image;
        addFild.rightViewMode = UITextFieldViewModeAlways;
    
[backScroll addSubview: addFild];





}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=mRGBColor(236, 235, 235);
//    if ([self isIphone5]) {
//        height=548;
//    }else{
//        height=460;
//    }
//    backScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320,height-100)];
//    backScroll.delegate=self;
//    backScroll.backgroundColor=[UIColor redColor];
//    backScroll.contentSize=CGSizeMake(320, height+100);
//    [self.view addSubview:backScroll];
//             
}
-(void)closeBtnBack{

    [self dismissViewControllerAnimated:YES completion:Nil];
}



-(void)buttonClicked:(UIButton*)sender
{
    if (sender.tag==1000)
    {
        if (self.photoArr.count<7) {            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
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
        rectY=btnView.frame.origin.y+btnView.frame.size.height+10;
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

   
}
-(void)addAllNAV{
    //    底部导航
    bottomBar=[[UIImageView alloc] initWithFrame:CGRectMake(0,height-44,320, 44)];
    bottomBar.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bottomBar];
    
    //    返回menu页的按钮
    UIButton*closeMenuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeMenuBtn setFrame:CGRectMake(10,height-44, 50, 44)];
    closeMenuBtn.contentMode=UIViewContentModeScaleAspectFit;
    [closeMenuBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
    [closeMenuBtn addTarget:self action:@selector(closeBtnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeMenuBtn];
    
    //        send的按钮
    UIButton*sendeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendeBtn setFrame:CGRectMake(280, self.view.frame.size.height-44, 50, 44)];
    sendeBtn.contentMode=UIViewContentModeScaleAspectFit;
    [sendeBtn setImage:[UIImage imageNamed:@"bottomBack.png"] forState:UIControlStateNormal];
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
@end
