//
//  SingleMenuViewController.h
//  JiaDe
//
//  Created by xuwenjuan on 13-6-17.
//  Copyright (c) 2013年 tagux imac04. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleMenuViewController;
@protocol SingleMenuViewDelegate <NSObject>
- (void)singleClickNavBarRightButton:(id)object;
- (void)singleClickTabBarRightButton:(id)object;
- (void)singleSelectedSubCateroyWihtInfo:(NSDictionary*)info;
@end
@interface SingleMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _departmentTable;
    NSMutableArray * _departMentArr;
    UIImageView * _bottomBar;
    int _height;
    PicUploadCateroy _cateroyId;
    DetailTextView * _dtView;
}

- (id)initWithCateroyId:(PicUploadCateroy)AcateroyId;

@property(nonatomic,assign)id<SingleMenuViewDelegate> delegate;
@property(nonatomic,strong)NSString*menuCStr;
@property(nonatomic,strong)NSString*menuEStr;
@property(nonatomic,assign)PicUploadCateroy cateroyId;
@end
