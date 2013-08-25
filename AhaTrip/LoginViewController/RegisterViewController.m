//
//  SCPRegisterViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"


@implementation RegisterViewController

@synthesize loginController = _loginController;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize backgroundControl = _backgroundControl;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize mailBindTextField = _mailBindTextField;
@synthesize registerButton = _registerButton;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    [super loadView];
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    view.bounces = NO;
    view.contentSize = view.frame.size;
    view.delegate = self;
    self.view = view;
    self.view.backgroundColor = [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addViews];
    [self addFunctionView];
    [self addTitleBar];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addViews
{
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _backgroundImageView.image = [UIImage imageNamed:@"register_bg.png"];
    [self.view addSubview:_backgroundImageView];
    _backgroundControl = [[UIControl alloc] initWithFrame:_backgroundImageView.bounds];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_backgroundControl];
    
}
- (void)addFunctionView
{
    _funcionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height -  373.f, 320, 373.f)];
    _funcionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_funcionView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allTextFieldsResignFirstResponder:)];
    gesture.delegate = self;
    [_funcionView addGestureRecognizer:gesture];
    _portraitImageButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 0, 100, 100)];
    _portraitImageButton.backgroundColor = [UIColor clearColor];
    [_portraitImageButton setImage:[UIImage imageNamed:@"register_image.png"] forState:UIControlStateNormal];
    _hasPortrait = NO;
    [_portraitImageButton addTarget:self action:@selector(portraitImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_funcionView addSubview:_portraitImageButton];
    
    
    UIView * bgmage = [[UIView alloc] initWithFrame:CGRectMake(145 , 0, 140, 35)];
    bgmage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(145 + 10 , 0, 120, 35)];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = TEXTLOLOR;
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"昵称";
    _usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _usernameTextField.backgroundColor = [UIColor clearColor];
    _usernameTextField.delegate = self;
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView * mainBindBg = [[UIView alloc] initWithFrame:CGRectMake(33, 115, 260, 35)];
    mainBindBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _mailBindTextField = [[UITextField alloc] initWithFrame:CGRectMake(33 + 10, 115, 240, 35)];
    _mailBindTextField.font = [UIFont systemFontOfSize:15];
    _mailBindTextField.textColor = TEXTLOLOR;
    _mailBindTextField.returnKeyType = UIReturnKeyNext;
    _mailBindTextField.placeholder = @"电子邮箱地址";
    _mailBindTextField.delegate = self;
    _mailBindTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mailBindTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _mailBindTextField.backgroundColor = [UIColor clearColor];
    _mailBindTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_mailBindTextField addTarget:self action:@selector(mailBindDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView * passBg = [[UIView alloc] initWithFrame:CGRectMake(33,160,260, 35)];
    passBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(33 + 10,160,240, 35)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = TEXTLOLOR;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _passwordTextField.backgroundColor = [UIColor clearColor];
    _mailBindTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_passwordTextField addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    UIView * birBg = [[UIView alloc] initWithFrame:CGRectMake(33, 205, 150, 35)];
    birBg.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _birthday  = [[BirthDayField alloc] initWithFrame:CGRectMake(33 + 10, 205, 240, 35)];
    _birthday.textFiled.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _birthday.textFiled.font = [UIFont systemFontOfSize:15];
    _birthday.textFiled.textColor = TEXTLOLOR;
    _birthday.textFiled.placeholder = @"生日(可选)";
    _birthday.textFiled.backgroundColor = [UIColor clearColor];
    _registerButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    [_registerButton setImage:[UIImage imageNamed:@"register_button.png"] forState:UIControlStateNormal];
    _registerButton.frame = CGRectMake(33, 285, 260, 45);
    [_registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    [_funcionView addSubview:_registerButton];
    [_funcionView addSubview:bgmage];
    [_funcionView addSubview:mainBindBg];
    [_funcionView addSubview:passBg];
    [_funcionView addSubview:birBg];
    [_funcionView addSubview:_usernameTextField];
    [_funcionView addSubview:_mailBindTextField];
    [_funcionView addSubview:_passwordTextField];
    [_funcionView addSubview:_birthday];
    [_funcionView addSubview:_registerButton];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![touch.view isKindOfClass:[UIButton class]];
}

- (void)addTitleBar
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(7, 7, 33, 33);
    [backButton setImage:[UIImage imageNamed:@"button_cancel.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 47)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:22.f];
    label.text = @"注册新账号";
    [self.view addSubview:label];
}

#pragma mark - TextFiledDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.text  = [textField.text lowercaseString];
}
- (void)agreeDeal:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        [_registerButton setUserInteractionEnabled:YES];
        [_registerButton setAlpha:1.0];
    }else{
        [_registerButton setAlpha:0.3];
        [_registerButton setUserInteractionEnabled:NO];
    }
}

- (void)backButtonClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark
- (void)portraitImageButtonClick:(UIButton *)button
{
    [self showActionSheet];
}
- (void)showActionSheet
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLCImagePickerController * picker = [[DLCImagePickerController alloc] init];
    picker.delegate = self;
    if (buttonIndex == 0) {
        [self presentModalViewController:picker animated:NO];
        [picker switchToLibraryWithAnimaion:NO];
    }else if(buttonIndex == 1){
        [self presentModalViewController:picker animated:YES];
    }
}

- (void)DLImagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog();
    UIImage * image = [info objectForKey:@"Image"];
    DLog(@"%f",image.size.width);
    [_portraitImageButton setImage:image forState:UIControlStateNormal];
    _hasPortrait = YES;
    [self dismissModalViewControllerAnimated:YES];
}


- (void)doRegister
{
//    if (!_hasPortrait) {
//        [self showPopAlerViewWithMes:@"请选择头像"];
//        return;
//    }
    if (![self cheackTest:_usernameTextField]) {
        [self showPopAlerViewWithMes:@"请填写用户名"];
        return;
    }
    if (![self cheackTest:_mailBindTextField]) {
        [self showPopAlerViewWithMes:@"请填写邮箱"];
        return;
    }
    if (![self checkeMail:_mailBindTextField.text]) {
        [self showPopAlerViewWithMes:@"邮箱不合法"];
        return;
    }
    if (![self cheackTest:_passwordTextField]) {
        [self showPopAlerViewWithMes:@"请填写密码"];
        return;
    }
    [self allTextFieldsResignFirstResponder:nil];
    [self waitForMomentsWithTitle:@"注册中" withView:self.view];
    UIImage * image = nil;
    if (_hasPortrait)
        image = [_portraitImageButton imageForState:UIControlStateNormal];
    [RequestManager registerWithEmail:_mailBindTextField.text UserName:_usernameTextField.text passpord:_passwordTextField.text isGril:[_birthday timeString] ? _birthday.isGirl:-1 portrait:image birthday:[_birthday timeString] success:^(NSString *response) {
        [self stopWaitProgressView:nil];
        [self handleLoginInfo:[[response JSONValue] objectForKey:@"result"]];
    } failure:^(NSString *error) {
        [self showTotasViewWithMes:@"网络异常,请稍后重试"];
        [self stopWaitProgressView:nil];
    }];
}
- (void)handleLoginInfo:(NSDictionary *)response
{
    DLog(@"%@",response);
    [LoginStateManager loginUserId:[NSString stringWithFormat:@"%@",[response objectForKey:@"uid"]] withToken:[response objectForKey:@"token"] RefreshToken:@"temp"];
    [self dismissModalViewControllerAnimated:YES];
}


-(BOOL)cheackTest:(UITextField *)filed
{
    return _usernameTextField.text && ![_usernameTextField.text isEqualToString:@""];
}

-(BOOL)checkeMail:(NSString *)str
{
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[a-z]([a-z0-9]*[-_]?[a-z0-9]+)*@([a-z0-9]*[-_]?[a-z0-9]+)+[\\.][a-z]{2,3}([\\.][a-z]{2})?$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    
    return numberofMatch;
}
#pragma mark Controll Action
- (void)allTextFieldsResignFirstResponder:(id)sender
{
    DLog();
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_mailBindTextField resignFirstResponder];
}
- (void)mailBindDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
}
#pragma mark
- (void)backHomeWithRespose:(NSDictionary *)response
{
    [self.navigationController popViewControllerAnimated:NO];
    LoginViewController * vc = _loginController;
    [vc handleLoginInfo:response];
}

#pragma mark KeyBoardnotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIScrollView * view = (UIScrollView *) self.view;
    view.scrollEnabled = YES;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = view.bounds.size;
    size.height += keyboardSize.height;
    view.contentSize = size;
    
    CGPoint point = view.contentOffset;
    point.y =  120;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    UIScrollView *view = (UIScrollView *) self.view;
    CGPoint point = view.contentOffset;
    point.y  =  0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    view.contentOffset = point;
    [UIView commitAnimations];
    view.scrollEnabled = NO;
    CGSize size = view.bounds.size;
    view.contentSize = size;
}

@end
