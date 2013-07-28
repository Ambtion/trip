//
//  Constants.h
#import <Foundation/Foundation.h>
//#import "ScrollNewsView.h"
//#import "NavBarView.h"
//#import "SubtitleView.h"

#import "ASIRequest.h"
#import "JSONKit.h"
//#import "SubtitleView.h"
#import "MBProgressHUD.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

@interface Constants : NSObject
//状态返回码
typedef enum
{
    LSucceed            = 1,            //请求成功
    LFailed             = 0,            //请求失败
    LNeedLogin          = -10,          //需要登录
    LNeedUpdate         = -8,           //需要更新客户端
    LUserNotExist       = -1,           //用户不存在
    LUserHasRegister    = -5,           //该用户已注册
    LUserHasBeen        =10
    
}LStatusCode;

#define kAddressPrefix          @"搜索位置"
#define mImageByName(name)        [UIImage imageNamed:name]

//第三方登录平台
typedef enum LOtherLoginPlatform
{
    LQQLogin    = 1,
    LSinaLogin  = 2
}LOtherLoginPlatform;

#define mWindow             [[[UIApplication sharedApplication] windows]lastObject]

#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/*
 *** UIView Tag
 */
#define ChineseLanguage                 [[[NSUserDefaults standardUserDefaults] objectForKey:@"CustomLanguage"] isEqualToString:@"Chinese"]

#define kNewsClassBtnTag     100
#define kScrollNewsBtnTag    130
#define kScrollNewsLblTag    140
#define iphoneHeight 
#define iphone4HEIGHT 
/*
*** HttpRequest API
 */
#define kTopicClassTag   10000
#define kTopicClass                 @"http://ipad.jiadeapp.com/ajax/news.news.php"

#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@end
