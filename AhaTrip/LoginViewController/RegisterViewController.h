//
//  SCPRegisterViewController.h
//  SohuCloudPics
//
//  Created by Chong Chen on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmailTextField.h"
#import "MBProgressHUD.h"
#import "ActionSheetPicker.h"

#define TEXTLOLOR  [UIColor whiteColor]

@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    MBProgressHUD * _alterView;
    UIButton * _portraitImageButton;
    UIView * _funcionView;
    UIButton * _manButton;
    UIButton * _womenButton;
    UITextField  * _birthday;
}
@property (weak, nonatomic) id loginController;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIControl * backgroundControl;
@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *mailBindTextField;
@property (strong, nonatomic) UIButton *registerButton;

@end
