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
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.bounces = NO;
    view.contentSize = view.frame.size;
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
    
    _portraitImageButton = [[UIButton alloc] initWithFrame:CGRectMake(33, 0, 100, 100)];
    _portraitImageButton.backgroundColor = [UIColor redColor];
    [_portraitImageButton addTarget:self action:@selector(portraitImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_funcionView addSubview:_portraitImageButton];
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(145 , 0, 140, 35)];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @" 昵称";
    _usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _usernameTextField.delegate = self;
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _mailBindTextField = [[UITextField alloc] initWithFrame:CGRectMake(33, 115, 260, 35)];
    _mailBindTextField.font = [UIFont systemFontOfSize:15];
    _mailBindTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _mailBindTextField.returnKeyType = UIReturnKeyNext;
    _mailBindTextField.placeholder = @" 电子邮箱地址";
    _mailBindTextField.delegate = self;
    _mailBindTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _mailBindTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];        _mailBindTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_mailBindTextField addTarget:self action:@selector(mailBindDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(33,160,260, 35)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @" 密码";
    _passwordTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];        _mailBindTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_passwordTextField addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _registerButton = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    _registerButton.frame = CGRectMake(33, 285, 260, 45);
    [_registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    [_funcionView addSubview:_registerButton];
    [_funcionView addSubview:_usernameTextField];
    [_funcionView addSubview:_mailBindTextField];
    [_funcionView addSubview:_passwordTextField];
    
    [_funcionView addSubview:_registerButton];

}
- (void)addTitleBar
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(7, 7, 33, 33);
    [backButton setImage:[UIImage imageNamed:@"back_Button.png"] forState:UIControlStateNormal];
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
- (void)portraitImageButtonClick:(UIButton *)button
{
    
}

- (void)doRegister
{
    //    if (!_usernameTextField.text || [_usernameTextField.text isEqualToString:@""]) {
    //        [self showPopAlerViewRatherThentasView:YES WithMes:@"您还没有填写用户名"];
    //        return;
    //    }
    //    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
    //        [self showPopAlerViewRatherThentasView:YES WithMes:@"您还没有填写密码"];
    //        return;
    //    }
    //    [self allTextFieldsResignFirstResponder:nil];
    //    [self waitForMomentsWithTitle:@"注册中"];
    //    NSString * username = [NSString stringWithFormat:@"%@@sohu.com",_usernameTextField.text];
    //    NSString * password = [NSString stringWithFormat:@"%@",_passwordTextField.text];
    //    [AccountLoginResquest resigiterWithuseName:username password:password nickName:nil sucessBlock:^(NSDictionary *response) {
    //        [AccountLoginResquest sohuLoginWithuseName:username password:password sucessBlock:^(NSDictionary * response) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [self backHomeWithRespose:response];
    //            });
    //        } failtureSucess:^(NSString *error) {
    //            [self stopWait];
    //            [self showPopAlerViewRatherThentasView:YES WithMes:error];
    //        }];
    //
    //    }failtureSucess:^(NSString *error) {
    //        [self stopWait];
    //        [self showPopAlerViewRatherThentasView:YES WithMes:error];
    //    }];
}
#pragma mark Controll Action
- (void)allTextFieldsResignFirstResponder:(id)sender
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_mailBindTextField resignFirstResponder];
}
- (void)mailBindDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
    
}
- (void)usernameDidEndOnExit
{
    [_mailBindTextField becomeFirstResponder];
}

#pragma mark
- (void)backHomeWithRespose:(NSDictionary *)response
{
    [self stopWait];
    [self.navigationController popViewControllerAnimated:NO];
    LoginViewController * vc = _loginController;
    [vc handleLoginInfo:response];
}

-(void)waitForMomentsWithTitle:(NSString*)str
{
    //    if (_alterView.superview) return;
    if (!_alterView) {
        _alterView = [[MBProgressHUD alloc] initWithView:self.view];
        _alterView.animationType = MBProgressHUDAnimationZoomOut;
        _alterView.labelText = str;
        [self.view addSubview:_alterView];
    }
    [_alterView show:YES];
}

-(void)stopWait
{
    DLog(@"%s",__FUNCTION__);
    [_alterView hide:YES];
}

#pragma mark KeyBoardnotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    UIScrollView * view = (UIScrollView *) self.view;
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGSize size = view.bounds.size;
    size.height += keyboardSize.height;
    view.contentSize = size;
    //    CGPoint point = view.contentOffset;
    //    point.y = 118;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    //    view.contentOffset = point;
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
    
    CGSize size = view.bounds.size;
    view.contentSize = size;
}
@end
