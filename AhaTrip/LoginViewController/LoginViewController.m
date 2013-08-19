//
//  SCPLoginViewController.m
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"

#define EMAIL_ARRAY ([NSArray arrayWithObjects:\
@"sohu.com", @"vip.sohu.com", @"chinaren.com", @"sogou.com", @"17173.com", @"focus.cn", @"game.sohu.com", @"37wanwan.com",\
@"126.com", @"163.com", @"qq.com", @"gmail.com", @"sina.com.cn", @"sina.com", @"yahoo.com", @"yahoo.com.cn", @"yahoo.cn", nil])

#define BACKGROUDCOLOR [UIColor colorWithRed:244.f/255 green:244.f/255 blue:244.f/255 alpha:1.f]
@implementation LoginViewController
@synthesize backgroundImageView = _backgroundImageView;
@synthesize backgroundControl = _backgroundControl;
@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView * view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    view.bounces = NO;
    view.scrollEnabled = NO;
    view.contentSize = view.frame.size;
    self.view = view;
    self.view.backgroundColor = BACKGROUDCOLOR;
    [self addsubViews];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)addsubViews
{
    //backGround
    CGRect bounds = self.view.bounds;
    _backgroundImageView = [[UIImageView alloc] initWithFrame:bounds];
    _backgroundImageView.image = [UIImage imageNamed:@"Login_bg.png"];
    [self.view addSubview:_backgroundImageView];
    _backgroundControl = [[UIControl alloc] initWithFrame:bounds];
    [_backgroundControl addTarget:self action:@selector(allTextFieldsResignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backgroundControl];
    [self addFunctionView];
}

- (void)addFunctionView
{
    _funtionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 285, 320, 285)];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allTextFieldsResignFirstResponder)];
    gesture.delegate = self;
    [_funtionView addGestureRecognizer:gesture];
    UIView * bgmage = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 215, 35)];
    bgmage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(18 + 10, 0, 205, 35)];
    _usernameTextField.font = [UIFont systemFontOfSize:15];
    _usernameTextField.textColor = TEXTLOLOR;
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.placeholder = @"使用电子邮箱地址";
    _usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _usernameTextField.backgroundColor = [UIColor clearColor];
    _usernameTextField.text = [[LoginStateManager lastUserName] copy];
    _usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_usernameTextField addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //输入密码
    UIView * bgmage2 = [[UIView alloc] initWithFrame:CGRectMake(18, 39, 215, 35)];
    bgmage2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(18 + 10, 39, 205, 35)];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    _passwordTextField.textColor = TEXTLOLOR;
    _passwordTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _passwordTextField.backgroundColor = [UIColor clearColor];
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    
    //登录按钮
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(238, 0, 64, 74);
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login_button.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //注册
    UIButton *  registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(18, 111, 284, 50);
    [registerButton setImage:[UIImage imageNamed:@"login_button_register.png"] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * forgetPassWord = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPassWord.frame = CGRectMake(240, 82 , 60, 13);
    [forgetPassWord setImage:[UIImage imageNamed:@"forget.png"] forState:UIControlStateNormal];
    forgetPassWord.backgroundColor = [UIColor clearColor];
    [forgetPassWord addTarget:self action:@selector(forgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [_funtionView addSubview:bgmage];
    [_funtionView addSubview:_usernameTextField];
    [_funtionView addSubview:bgmage2];
    [_funtionView addSubview:_passwordTextField];
    [_funtionView addSubview:registerButton];
    [_funtionView addSubview:loginButton];
    [_funtionView  addSubview:forgetPassWord];
    
    
    //第三方登录
    UIImageView * oauthorTitle = [[UIImageView alloc] initWithFrame:CGRectMake(18, 183, 165, 50)];
    oauthorTitle.image = [UIImage imageNamed:@"oauthor_Title.png"];
    oauthorTitle.backgroundColor = [UIColor clearColor];
    [_funtionView addSubview:oauthorTitle];
    
    
    UIButton * qqbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqbutton.frame = CGRectMake(193,183, 50, 50);
    [qqbutton setImage:[UIImage imageNamed:@"Login_button_qq_normal.png"] forState:UIControlStateNormal];
    [qqbutton addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_funtionView addSubview:qqbutton];
    
    UIButton * sinabutton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinabutton.frame = CGRectMake(251,183, 50, 50);
    [sinabutton setImage:[UIImage imageNamed:@"Login_button_sina_normal.png"] forState:UIControlStateNormal];
    [sinabutton addTarget:self action:@selector(sinaLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_funtionView addSubview:sinabutton];
    
    [self.view addSubview:_funtionView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return ![touch.view isKindOfClass:[UIButton class]];
}
#pragma mark -
- (void)allTextFieldsResignFirstResponder
{
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

- (void)usernameDidEndOnExit
{
    [_passwordTextField becomeFirstResponder];
}

#pragma mark  - ButtonClick
- (void)cancelLogin:(UIButton *)button
{
    DLog(@"self.nav.nav%@",self.navigationController.navigationController);
    if (self.navigationController.presentingViewController) {
        //等待qq控件恢复到远状态
        [self performSelector:@selector(cancelPresentingController) withObject:nil afterDelay:0.3];
        return;
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([_delegate respondsToSelector:@selector(loginViewController:cancleClick:)])
        [_delegate loginViewController:self cancleClick:button];
}
- (void)cancelPresentingController
{
    [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
}
- (void)loginButtonClicked:(UIButton*)button
{
    if (!_usernameTextField.text|| [_usernameTextField.text isEqualToString:@""]) {
        [self showPopAlerViewWithMes:@"您还没有填写用户名" withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
        return;
    }
    if (!_passwordTextField.text || [_passwordTextField.text isEqualToString:@""]) {
        [self showPopAlerViewWithMes:@"您还没有填写密码" withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
        return;
    }
    NSString * useName = [NSString stringWithFormat:@"%@",[_usernameTextField.text lowercaseString]];
    NSString * passWord = [NSString stringWithFormat:@"%@",_passwordTextField.text];
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    
    [RequestManager loingWithUserName:useName passpord:passWord success:^(NSString *response) {
        NSDictionary * dic = [[response JSONValue] objectForKey:@"result"];
        [hud hide:YES];
        DLog(@"%@",dic);
        if ([[dic objectForKey:@"code"] intValue] == 200) {
            [LoginStateManager storelastName:_usernameTextField.text];
            [self handleLoginInfo:dic];
        }else{
            [self showPopAlerViewWithMes:@"用户名或者密码不对" withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
        }
    } failure:^(NSString *error) {
        [hud hide:YES];
        
    }];
}
- (void)registerButtonClicked:(UIButton *)button
{
    [_passwordTextField resignFirstResponder];
    [_usernameTextField resignFirstResponder];
    RegisterViewController * reg = [[RegisterViewController alloc] init];
    reg.loginController = self;
    DLog(@"%@",self.navigationController);
    [self.navigationController pushViewController:reg animated:YES];
}

#pragma mark Handle Login Result

- (void)handleLoginInfo:(NSDictionary *)response
{
    DLog(@"%@",response);
    [LoginStateManager loginUserId:[NSString stringWithFormat:@"%@",[response objectForKey:@"uid"]] withToken:[response objectForKey:@"token"] RefreshToken:@"temp"];
    //    [LoginStateManager loginUserId:@"2" withToken:@"tRyW4rLBiJHffQ" RefreshToken:@"sdf"];
    [self cancelLogin:nil];
}
- (void)showError:(NSString *)error
{
    //    [self showPopAlerViewRatherThentasView:YES WithMes:error];
    if ([_delegate respondsToSelector:@selector(loginViewController:loginFailtureWithinfo:)])
        [_delegate loginViewController:self loginFailtureWithinfo:error];
}

#pragma mark OAuth
- (void)sinaLogin:(UIButton*)button
{
    [[self AppDelegate] sinaLoginWithDelegate:self];
}
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    DLog(@"%@",[[self AppDelegate] sinaweibo].accessToken);
    [self handleLoginInfo:nil];
}
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    [self showTotasViewWithMes:@"授权失败"];
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    [self showTotasViewWithMes:@"授权失败"];
}

#pragma mark QQ
- (void)qqLogin:(UIButton *)button
{
    [[self AppDelegate] qqLoginWithDelegate:self];
}
- (void)tencentDidLogin
{
    DLog(@"%@",[[self AppDelegate] tencentOAuth].accessToken);
    [self handleLoginInfo:nil];
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [self showTotasViewWithMes:@"授权失败"];
}
- (void)tencentDidNotNetWork
{
    [self showTotasViewWithMes:@"授权失败"];
}
#pragma forgetPassWord
- (void)forgetPassWord:(id)sender
{
    //忘记密码
}
#pragma mark Keyboard lifeCircle
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
    //视图消失时自动失去第一响应者,为了保持动画一致性
    if ([LoginStateManager isLogin]) return;
    DLog(@"%s",__FUNCTION__);
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
