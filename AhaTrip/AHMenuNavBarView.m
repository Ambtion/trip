//
//  AHCusNavBarView.m
//  AhaTrip
//
//  Created by Qu on 13-6-22.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "AHMenuNavBarView.h"

@interface AHMenuOverlay:UIView
@property(nonatomic,weak)id menuObject;
@end

@implementation AHMenuOverlay
@synthesize menuObject;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touched = [[touches anyObject] view];
    if (touched == self) {
        if ([self.menuObject respondsToSelector:@selector(hideTitleMenu)]) {
            [self.menuObject hideTitleMenu];
        }
    }
}

@end

@interface AHMenuView : UIImageView
@end
@implementation AHMenuView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 48)];
    if (self) {
        self.image = [UIImage imageNamed:@"NavBar_bg_white.png"];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}
@end
@implementation AHMenuNavBarView
@synthesize delegate;

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _superView = view;
        _overView = [[AHMenuOverlay alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
        _overView.menuObject = self;
        _isShowMenu = NO;
        [_superView addSubview:_overView];
        [self overViewAddMenuView];
        [self overViewAddTitleMenuView];
    }
    return self;
}
- (void)overViewAddMenuView
{
    _menuView = [[AHMenuView alloc] initWithFrame:CGRectZero];
    _menuView.autoresizingMask = UIViewAutoresizingNone;
    [self setMenuViewActionButton];
    [_overView addSubview:_menuView];
}
- (void)overViewAddTitleMenuView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(60, 37, 200, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_overView addSubview:_tableView];
    _titleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _titleButton.frame = CGRectMake(60, 7, 200, 30);
    _titleButton.tag = 300;
    [_titleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_overView addSubview:_titleButton];
}
- (void)setMenuViewActionButton
{
    UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = CGRectMake(7, 7, 30, 30);
    leftbutton.tag = 100;
    [leftbutton setImage:[UIImage imageNamed:@"ItemMenuBarBg.png"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:leftbutton];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(320 - 44, 7, 30, 30);
    rightButton.tag = 200;
    [rightButton setImage:[UIImage imageNamed:@"ItemSearchBarBg.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_menuView addSubview:rightButton];
    
}


- (void)buttonClick:(UIButton *)button
{
    
    switch (button.tag) {
        case 100:
            if ([delegate respondsToSelector:@selector(menuButtonClick:)])
                [delegate menuButtonClick:button];
            break;
        case 200:
            if ([delegate respondsToSelector:@selector(searchButtonClick:)])
                [delegate searchButtonClick:button];
            break;
        case 300:
            if (_isShowMenu)
                [self hideTitleMenu];
            else
                [self showTitleMenu];
            
            break;
        default:
            break;
    }
}

- (void)showTitleMenu
{
    [_overView setUserInteractionEnabled:NO];
    CGFloat heigth = MIN([[self getCurArray] count] * 20 , 200.f);
    CGRect tableRect = _tableView.frame;
    tableRect.size.height = heigth;
    CGRect finalRect = tableRect;
    tableRect.size.height += 5;
    tableRect.origin.y += 2;
    [UIView animateWithDuration:0.2 animations:^{
        _overView.frame = _superView.bounds;
        _tableView.frame = tableRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _tableView.frame = finalRect;
        } completion:^(BOOL finished) {
            [_tableView setScrollEnabled:heigth < _tableView.contentSize.height];
            _isShowMenu = YES;
            [_overView setUserInteractionEnabled:YES];
            [_menuView setUserInteractionEnabled:NO];
        }];
    }];
}
- (void)hideTitleMenu
{
    [_overView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        _overView.frame =  CGRectMake(0, 0, 320, 48);
        _tableView.frame= CGRectMake(60, 37, 200, 0);
    } completion:^(BOOL finished) {
        _isShowMenu = NO;
        [_overView setUserInteractionEnabled:YES];
        [_menuView setUserInteractionEnabled:YES];
    }];
}
- (void)hideMenuBar
{
    if (![self isShowMenuBar]) return;
    [_overView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        _overView.frame =  CGRectMake(0, -48, 320, 48);
    } completion:^(BOOL finished) {
        _isShowMenu = NO;
        [_overView setUserInteractionEnabled:YES];
        [_menuView setUserInteractionEnabled:YES];
    }];
}
- (void)showMenuBar
{
    if ([self isShowMenuBar]) return;
    [_overView setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.3 animations:^{
        _overView.frame =  CGRectMake(0, 0, 320, 48);
    } completion:^(BOOL finished) {
        _isShowMenu = NO;
        [_overView setUserInteractionEnabled:YES];
        [_menuView setUserInteractionEnabled:YES];
    }];
}
- (BOOL)isShowMenuBar
{
    return _overView.frame.origin.y == 0;
}
- (void)setStringTitleArray:(NSArray *)titleArray curString:(NSString *)title
{
    [_titleButton setTitle:title forState:UIControlStateNormal];
    _stringDataSource = titleArray;
    [_tableView  reloadData];
}

- (void)setInfoTitleArray:(NSArray *)infoArray curInfo:(NSString *)info
{
    //取决后台数据结构
}

#pragma mark DelegateDatasource
- (NSArray *)getCurArray
{
    if (_stringDataSource)
        return _stringDataSource;
    if (_infoDataSource)
        return _infoDataSource;
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getCurArray] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellString = @"CELL";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    id info = [[self getCurArray] objectAtIndex:indexPath.row];
    if ([info isKindOfClass:[NSString class]]) {
        cell.textLabel.text = info;
    }else{
        //取决后台数据结构
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideTitleMenu];
    id source = [[self getCurArray] objectAtIndex:indexPath.row];
    if ([source isKindOfClass:[NSString class]]) {
        [_titleButton setTitle:source forState:UIControlStateNormal];
    }else{
        //取决后台数据结构
    }
    if ([delegate respondsToSelector:@selector(titleMenuClickWithInfo:)]) {
        [delegate titleMenuClickWithInfo:[[self getCurArray] objectAtIndex:indexPath.row]];
    }
}
@end
