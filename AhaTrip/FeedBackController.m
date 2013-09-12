//
//  SCPFeedBackController.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-7.
//
//

#import "FeedBackController.h"
#import "EmojiUnit.h"
#import <QuartzCore/QuartzCore.h>

#define DESC_COUNT_LIMIT 200

#define PLACEHOLDER  @"在使用过程中有什么意见或建议，请尽情地..."
#define TITLE_DES @"意见反馈"

#define mRGB(a,b,c)  [UIColor colorWithRed:a/255.f green:b/255.f blue:c/255.f alpha:1]



@implementation FeedBackController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self addSubviews];
}

- (void)settingnavigationBack:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButton:(UIButton *)button
{
    if ([EmojiUnit stringContainsEmoji:_textView.text]) {
        UIAlertView * tip = [[UIAlertView alloc] initWithTitle:nil message:@"反馈内容不能包含特殊字符或表情" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        return;
    }
    [self feedBackWithidea:_textView.text];
}
- (void)feedBackWithidea:(NSString *)idea
{
    @try {
        UMFeedback * umFeedBack = [UMFeedback sharedInstance];
        [umFeedBack setAppkey:UM_APP_KEY delegate:self];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:idea forKey:@"content"];
        //        [dic setObject:[NSDictionary dictionaryWithObject:[LoginStateManager currentUserId] forKey:@"user_id"] forKey:@"contact"];
        [umFeedBack post:dic];
    }
    @catch (NSException *exception) {
        [self showTotasViewWithMes:@"当前网络不给力,请稍后重试"];
    }
    @finally {
        
    }
}

- (void)postFinishedWithError:(NSError *)error
{
    if (error) {
        [self showTotasViewWithMes:@"反馈失败"];
    }else{
        [self showTotasViewWithMes:@"成功提交,感谢您的反馈"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
- (void)addSubviews
{
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f];
    //    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    //    imageView.image = [UIImage imageNamed:@"title_feedback.png"];
    //    imageView.image = nil;
    //    [self.view addSubview:imageView];
    //加载topBar
    self.view.backgroundColor=mRGB(236, 235, 235);
    UIImageView* topBarImag =[[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 44)];
    topBarImag.backgroundColor=mRGB(50, 200, 160);
    [self.view addSubview:topBarImag];
    [topBarImag setUserInteractionEnabled:YES];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(5, 0, 160, 44);
    titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = TITLE_DES;
    [self.view addSubview:titleLabel];
    titleLabel.center = CGPointMake(160, 22);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)] ;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    //    返回menu页的按钮
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10,0, 44, 44)];
    backButton.contentMode=UIViewContentModeCenter;
    [backButton setImage:[UIImage imageNamed:@"feedBackBack.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(settingnavigationBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //send的按钮
    _saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setFrame:CGRectMake(250, 0 , 60, 44)];
    _saveButton.contentMode=UIViewContentModeCenter;
    [_saveButton setImage:[UIImage imageNamed:@"feedBacksent"] forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton setAlpha:0.3];
    [_saveButton setUserInteractionEnabled:NO];
    [self.view addSubview:_saveButton];
    
    _textView_bg = [[UIView alloc] initWithFrame:CGRectMake(8, 122 - 50, 304, 134 + 50)];
    _textView_bg.backgroundColor = [UIColor clearColor];
    _textView_bg.layer.cornerRadius = 5.f;
    _textView_bg.layer.borderColor = [UIColor colorWithRed:222.f/255.f green:222.f/255.f blue:222.f/255.f alpha:1].CGColor;
    _textView_bg.layer.borderWidth = 1.f;
    _textView_bg.layer.masksToBounds = NO;
    _textView_bg.layer.shouldRasterize = NO;
    [self.view addSubview:_textView_bg];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(2, 2, 300, _textView.frame.size.height - 4)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font =  [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    _textView.returnKeyType = UIReturnKeyDefault;
    _textView.delegate = self;
    
    [_textView becomeFirstResponder];
    _textView.textColor = [UIColor colorWithRed:102.f/255 green:102.f/255 blue:102.f/255 alpha:1];
    
    [_textView_bg addSubview:_textView];
    _placeHolder = [[UITextField alloc] initWithFrame:CGRectMake(10, 6, 250, 50)];
    _placeHolder.placeholder = PLACEHOLDER;
    [_placeHolder setUserInteractionEnabled:NO];
    [_textView addSubview:_placeHolder];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGFloat heigth = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect rect = _textView_bg.frame;
    rect.size.height = self.view.bounds.size.height - heigth - rect.origin.y - 8;
    [UIView animateWithDuration:0.3 animations:^{
        _textView_bg.frame = rect;
        _textView.frame = CGRectMake(2, 2, _textView_bg.frame.size.width - 4, _textView_bg.frame.size.height - 4);
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        _textView_bg.frame = CGRectMake(8, 122, 304, 134);
        _textView.frame = CGRectMake(2, 2, _textView_bg.frame.size.width - 4, _textView_bg.frame.size.height - 4);
    }];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > DESC_COUNT_LIMIT) ? NO : YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self.view];
    if ([touch.view isKindOfClass:[UIButton class]] || CGRectContainsPoint(CGRectMake(10, 105, 300, 150), point))
        return NO;
    return YES;
}
- (void)handleGuesture:(UITapGestureRecognizer *)gesture
{
    //    [_textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text && ![textView.text isEqualToString:@""]) {
        [_saveButton setAlpha:1.0];
        [_saveButton setUserInteractionEnabled:YES];
        if (!_placeHolder.hidden)
            [_placeHolder setHidden:YES];
    }else{
        [_saveButton setAlpha:0.3];
        [_saveButton setUserInteractionEnabled:NO];
        if (_placeHolder.hidden)
            [_placeHolder setHidden:NO];
    }
}

@end
