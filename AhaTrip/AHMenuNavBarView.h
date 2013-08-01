//
//  AHCusNavBarView.h
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AHMenuView;
@class AHMenuOverlay;
@protocol AHMenuNavBarViewDelegate <NSObject>
- (void)searchButtonClick:(UIButton *)button;
- (void)menuButtonClick:(UIButton *)button;
- (void)titleMenuClickWithInfo:(id)info;
@end

@interface AHMenuNavBarView : NSObject <UITableViewDataSource,UITableViewDelegate>
{
    __weak UIView * _superView;
    AHMenuOverlay * _overView;
    AHMenuView * _menuView;
    UITableView * _tableView;
    UIButton * _titleButton;
    UILabel * _titleLabel;
    NSArray * _stringDataSource;
    NSArray * _infoDataSource;
    BOOL _isShowMenu;
}
@property(nonatomic,weak)id<AHMenuNavBarViewDelegate> delegate;
- (id)initWithView:(UIView *)view;
- (void)setStringTitleArray:(NSArray *)titleArray curString:(NSString *)title;
- (void)setInfoTitleArray:(NSArray *)infoArray curInfo:(NSString *)info;

- (void)hideMenuBar;
- (void)showMenuBar;
- (void)hideTitleMenu;
@end
