//
//  SettingController.m
//  AhaTrip
//
//  Created by sohu on 13-7-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "SettingController.h"
#import "FeedBackController.h"
#import "PlazeViewController.h"
#import "UIImageView+WebCache.h"
#import "AboutViewController.h"

static NSString * secTitle[3] = {@"账户",@"分享到",@"其他"};
static NSString * titleSection1[2] = {@"新浪微博",@"腾讯微博"};
static NSString * iconSection1[2] = {@"setting_Icon_sina.png",@"setting_Icon_qq.png"};
static NSString * titleSection2[5] = {@"关于我们",@"给AhaTrip打分",@"意见反馈",@"清除缓存",@"检查版本更新"};

@implementation SettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    shouldUpload = YES;
    self.view.backgroundColor = [UIColor colorWithRed:235.f/255 green:235.f/255 blue:235.f/255 alpha:1.f];
    [self getUserInfo];
    [self addTableView];
    [self addNavBar];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    self.viewDeckController.delegate = nil;
    self.viewDeckController.rightController = nil;
    if (shouldUpload){
        [self getUserInfo];
    }else{
        shouldUpload = YES;
    }
    [_tableView reloadData];
}
- (void)getUserInfo
{
    [RequestManager getUserInfoWithUserId:[LoginStateManager currentUserId] success:^(NSString *response) {
        NSDictionary  * userInfo = [[response JSONValue] objectForKey:@"user"];
        DLog(@"%@",userInfo);
        acountSource = [[AcountSettingCellDataSource alloc] init];
        acountSource.poraitImage =[NSString stringWithFormat:@"%@", [userInfo objectForKey:@"thumb"]];
        acountSource.userName = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"username"]];
        acountSource.userDes = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"signature"]];
        acountSource.birthday = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"birth"]];
        acountSource.sex = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"sex"]];
        [_tableView reloadData];
    } failure:^(NSString *error) {
       
    }];
}

- (void)addNavBar
{
    UIImageView * bar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_bar.png"]];
    [bar setUserInteractionEnabled:YES];
    bar.frame = CGRectMake(0, 0, 320, 48);
    bar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bar];
    UIButton * done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(320 - 77, 7, 70, 30);
    [done setImage:[UIImage imageNamed:@"setting_bar_done.png"] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:done];
    
    UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(7, 7, 30, 30);
    leftbutton.tag = 100;
    [leftbutton setImage:[UIImage imageNamed:@"ItemMenuBarBg.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(leftbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:leftbutton];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)style:UITableViewStyleGrouped];
    UIView * bgview = [[UIView alloc] initWithFrame:_tableView.bounds];
    bgview.backgroundColor = [UIColor colorWithRed:235.f/255 green:235.f/255 blue:235.f/255 alpha:1];
    _tableView.backgroundView = bgview;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    view.backgroundColor = [UIColor clearColor];
    UIButton * logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 300, 40)];
    [logoutButton setImage:[UIImage imageNamed:@"setting_logout.png"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:logoutButton];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
}

#pragma mark
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return secTitle[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 426.f - 2;
            break;
        case 1:
        case 2:
            return 42.f;

    }
    return 0.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 5;
            break;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellId = @"CELL_0";
        _acountCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!_acountCell) {
            _acountCell = [[AcountSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            _acountCell.delegate = self;
        }
        _acountCell.dataSouce = acountSource;
        return _acountCell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (!_sinaCell) {
                _sinaCell = [[BindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                _sinaCell.delegate = self;
                _sinaCell.iconImageView.image = [UIImage imageNamed:iconSection1[indexPath.row]];
                _sinaCell.nameLabel.text = titleSection1[indexPath.row];
                [_sinaCell.bindSwitch setOn:[LoginStateManager isSinaBind]];
            }
            [_sinaCell.lineView setHidden:YES];
            return _sinaCell;
        }else{
            if (!_qqCell) {
                _qqCell = [[BindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
                _qqCell.delegate = self;
                _qqCell.iconImageView.image = [UIImage imageNamed:iconSection1[indexPath.row]];
                _qqCell.nameLabel.text = titleSection1[indexPath.row];
                [_qqCell.bindSwitch setOn:[LoginStateManager isQQBing]];
            }
            [_qqCell.lineView setHidden:NO];
            return _qqCell;
        }
        return nil;
    }
    if (indexPath.section == 2) {
        static NSString * cellId = @"CELL_2";
        TitleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[TitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = titleSection2[indexPath.row];
        [cell.lineView setHidden:indexPath.row != 4];
        return cell;
    }
    return nil;
}

#pragma mark Action
- (void)leftbuttonClick:(UIButton *)button
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}
- (void)doneButtonClick:(UIButton *)button
{
    [_acountCell registerAllResopner];
    [RequestManager updateUserInfoWithName:_acountCell.userNameLabel.text des:_acountCell.userDes.text birthday:[_acountCell.birthday timeString] isGril:_acountCell.birthday.isGirl portrait:_acountCell.portraitImage.imageView.image success:^(NSString *response) {
        [self showTotasViewWithMes:@"修改成功"];
    } failure:^(NSString *error) {
        [self showTotasViewWithMes:@"修改失败"];
    }];
}

#pragma ChnagePortrait

- (void)acountSettingCell:(AcountSettingCell *)cell changeImage:(UIButton *)button
{
    DLog();
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
    [_acountCell.portraitImage.imageView setImage:image];
    shouldUpload  = NO;
    DLog(@"%f",image.size.width);
    [self dismissModalViewControllerAnimated:YES];

}


- (void)acountSettingCellDidBeginEdit:(AcountSettingCell *)cell
{
    CGFloat offsetY = 300;
    if (_tableView.contentOffset.y < offsetY)
        [_tableView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: //关于
                [self.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
                break;
            case 1: //评分
                [self rating];
                break;
            case 2: //反馈
                [self.navigationController pushViewController:[[FeedBackController alloc] init] animated:YES];
                break;
            case 3: //缓冲
                [self showPopAlerViewWithMes:@"确认删除缓存" withDelegate:self cancelButton:@"取消" otherButtonTitles:@"确认",nil];
                break;
                case 4: //检查版本
                [self onCheckVersion];
                break;
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:@"确认删除缓存"]) {
        if (buttonIndex == 1) {
            [CacheManager removeAllCache];
        }
    }
    if ([[alertView message] isEqualToString:@"确认登出"]) {
        if (buttonIndex == 1) {
            [LoginStateManager logout];
            self.viewDeckController.centerController = [[self leftMenuController] plazeController];
        }
    }
}
#pragma mark logout
- (void)logoutButtonClick:(UIButton *)button
{
    [self showPopAlerViewWithMes:@"确认登出" withDelegate:self cancelButton:@"取消" otherButtonTitles:@"确认",nil];
}

#pragma checkou Version
- (void)rating
{
    NSDictionary * dic = [self getAppInfoFromNet];
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:[NSURL URLWithString:[dic objectForKey:@"url"]]];    
}
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSNumber * currentVersion = [infoDic objectForKey:@"VersionCode"];
    NSDictionary * dic = [self getAppInfoFromNet];
    DLog(@"%@",dic);
    NSNumber * newVersion = [dic objectForKey:@"version"];
    BOOL isUpata = [self CompareVersionFromOldVersion:currentVersion newVersion:newVersion];

    if (isUpata) {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:[dic objectForKey:@"url"]]];
    }else{
        [self showPopAlerViewWithMes:@"当前已是最新版本" withDelegate:self cancelButton:@"确定" otherButtonTitles:nil];
    }
}
-(BOOL)CompareVersionFromOldVersion : (NSNumber *)oldVersion newVersion : (NSNumber *)newVersion
{
    return ([oldVersion intValue] < [newVersion intValue]);
}
- (NSDictionary *)getAppInfoFromNet
{
    NSString *URL =[NSString stringWithFormat:@"http://yyz.ahatrip.info/api/version?token=%@",[LoginStateManager currentToken]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError * error = nil;
    NSData * recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    return [[results JSONValue] objectForKey:@"result"];
    return nil;
}

#pragma bind
#pragma mark Bind
- (void)BindCell:(BindCell *)cell SwithChanged:(UISwitch *)bindSwitch
{

    NSIndexPath * path = [_tableView indexPathForCell:cell];
    if (path.row == 0 && bindSwitch.isOn) {// sina
        if (bindSwitch.isOn) {
            if (![LoginStateManager isSinaBind]) {
                [self sinaLogin:nil];
            }
        }
    }else{ //qq
        if (![LoginStateManager isQQBing] && bindSwitch.isOn) {
            [self qqLogin:nil];
        }
    }
}

#pragma mark QQ
- (void)qqLogin:(UIButton *)button
{
    [[self AppDelegate] qqLoginWithDelegate:self];
}
- (void)tencentDidLogin
{
    [RequestManager bindWithAccessToken:[[self AppDelegate] tencentOAuth].accessToken ToSina:YES Success:^(NSString *response) {
        DLog(@"%@",response);
        [RequestManager createdFriendsWithQQToken:[[self AppDelegate] tencentOAuth].accessToken openId:[[self AppDelegate] tencentOAuth].openId Success:^(NSString *response) {
            [LoginStateManager storeQQTokenInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[self AppDelegate] tencentOAuth].openId,@"openid",[[self AppDelegate] tencentOAuth].accessToken,@"access_token", nil]];
            DLog(@"%@",response);
        } failure:^(NSString *error) {
            
        }];
    } failure:^(NSString *error) {
        
    }];
}
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    [_qqCell.bindSwitch setOn:NO];
    [self showTotasViewWithMes:@"授权失败"];
}
- (void)tencentDidNotNetWork
{
    [_qqCell.bindSwitch setOn:NO];
    [self showTotasViewWithMes:@"授权失败"];
}

#pragma mark OAuth
- (void)sinaLogin:(UIButton*)button
{
    [[self AppDelegate] sinaLoginWithDelegate:self];
}
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
   
    [RequestManager bindWithAccessToken:[sinaweibo accessToken] ToSina:YES Success:^(NSString *response) {
        DLog(@"%@",response);
        [LoginStateManager storeSinaTokenInfo:[NSDictionary dictionaryWithObjectsAndKeys:sinaweibo.userID,@"userID",sinaweibo.accessToken,@"access_token", nil]];
        [RequestManager createdFriendsWithSinaToken:sinaweibo.accessToken Success:^(NSString *response) {
            DLog(@"%@",response);
        } failure:^(NSString *error) {
            
        }];
    } failure:^(NSString *error) {
        
    }];
}
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    [_sinaCell.bindSwitch setOn:NO];
    [self showTotasViewWithMes:@"授权失败"];
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    [_sinaCell.bindSwitch setOn:NO];
    [self showTotasViewWithMes:@"授权失败"];
}

@end
