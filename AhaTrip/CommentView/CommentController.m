//
//  CommentController.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CommentController.h"
#import "UIImageView+WebCache.h"
#import "EmojiUnit.h"

@interface CommentController ()

@end

@implementation CommentController

- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}
- (id)initWithBgImage:(UIImage*)image
{
    self = [super init];
    if (self) {
        _blurImgage = image;
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(commentkeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(commentkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addBgViewWithImage:_blurImgage];
    [self addTableView];
    [self addCommentView];
    [self addBackButton];
    _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    [self refrshDataFromNetWork];
}
- (void)addBgViewWithImage:(UIImage *)image
{
    _myBgView  = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _myBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _myBgView.image = image;
    [self.view addSubview:_myBgView];
}

- (void)addTableView
{
    _refrehsTableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height - 44 - 38) style:UITableViewStylePlain];
    _refrehsTableView.backgroundColor =  [UIColor clearColor];
    _refrehsTableView.pDelegate = self;
    _refrehsTableView.dataSource = self;
    [self.view addSubview:_refrehsTableView];
}

- (void)addCommentView
{
    commentView = [[MakeCommentView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 38, 320, 38)];
    [self.view addSubview:commentView];
    commentView.delegte = self;
    [commentView addresignFirTapOnView:self.view];
}
- (void)addBackButton
{
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"comment_back_button.png"] forState:UIControlStateNormal];
    backButton.center = CGPointMake(self.view.frame.size.width /2.f, 5 + backButton.frame.size.height /2.f);
    [self.view addSubview:backButton];
}

- (CGSize)getIdentifyImageSizeWithImageView:(UIImage *)image
{
    if (!image) return CGSizeZero;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    CGRect frameRect = self.view.bounds;
    CGRect rect = CGRectZero;
    CGFloat scale = MAX(frameRect.size.width / w, frameRect.size.height / h);
    rect = CGRectMake(0, 0, w * scale, h * scale);
    return rect.size;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [commentView.textView resignFirstResponder];
}
#pragma mark KeyBord
- (void)commentkeyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGFloat heigth = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSNumber *duration = [dic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue]?[duration doubleValue] : 0.25 animations:^{
        commentView.frame = CGRectMake(0, self.view.frame.size.height - 38 - heigth, 320, 38);
    }];
}

- (void)commentkeyboardWillHide:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    NSNumber *duration = [dic objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue]?[duration doubleValue] : 0.25 animations:^{
        commentView.frame = CGRectMake(0, self.view.frame.size.height - 38, 320, 38);
    }];
}

- (void)commetButtonClick:(UIButton *)button
{
    
    if ([EmojiUnit stringContainsEmoji:commentView.textView.internalTextView.text]) {
        UIAlertView * tip = [[UIAlertView alloc] initWithTitle:nil message:@"评论内容不能包含特殊字符或表情" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [tip show];
        return;
    }
    //    [RequestManager postCommentWithSourceType:type andSourceID:sourceId onwerID:self.ownerId andAccessToken:[LoginStateManager currentToken] comment:commentView.textView.internalTextView.text success:^(NSString *response) {
    //        [_dataSourceArray insertObject:[self getCommentSoureWithComment:commentView.textView.internalTextView.text] atIndex:0];
    //        commentView.textView.internalTextView.text = nil;
    //        [commentView.textView resignFirstResponder];
    //        [_refrehsTableView reloadData];
    //        _isSending  = NO;
    //    } failure:^(NSString *error) {
    //        [self showPopAlerViewRatherThentasView:NO WithMes:error];
    //        [commentView.textView resignFirstResponder];
    //        _isSending  = NO;
    //    }];
}

- (CommentCellDeteSource *)getCommentSoureWithComment:(NSString *)comment
{
    //临时
    CommentCellDeteSource * dataSource = [[CommentCellDeteSource alloc] init];
    dataSource.portraitUrl = @"";
    dataSource.userName = @"ok";
    dataSource.userId = @"123";
    dataSource.commentStr = comment;
    return dataSource;
}

#pragma mark refrshDataFromNetWork
- (void)pullingreloadTableViewDataSource:(id)sender
{
    [self refrshDataFromNetWork];
}
- (void)pullingreloadMoreTableViewData:(id)sender
{
    [self getMoreFromNetWork];
}
- (void)refrshDataFromNetWork
{
    //    _isLoadingMax = NO;
    //    [RequestManager getCommentWithSourceType:type andSourceID:sourceId page: 1 success:^(NSString *response) {
    //        [_dataSourceArray removeAllObjects];
    //        [self addDataSourceWithArray:[[response JSONValue] objectForKey:@"comments"]];
    //        [_refrehsTableView didFinishedLoadingTableViewData];
    //
    //    } failure:^(NSString *error) {
    //        [self showPopAlerViewRatherThentasView:NO WithMes:error];
    //        [_refrehsTableView didFinishedLoadingTableViewData];
    //    }];
    //    [RequestManager getUserInfoWithId:[LoginStateManager currentUserId] success:^(NSString *response) {
    //        userInfo = [response JSONValue];
    //    } failure:^(NSString *error) {
    //        [self addDataSourceWithArray:nil];
    //    }];
}

- (void)addDataSourceWithArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++)
        [_dataSourceArray addObject:[self getCellDataSourceFromInfo:[array objectAtIndex:i]]];
    [_refrehsTableView reloadData];
}

- (CommentCellDeteSource *)getCellDataSourceFromInfo:(NSDictionary *)info
{
    CommentCellDeteSource * data = [[CommentCellDeteSource alloc] init];
    data.userId = [NSString stringWithFormat:@"%@",[info objectForKey:@"user_id"]];
    data.userName = [info objectForKey:@"user_nick"];
    data.commentStr = [info objectForKey:@"content"];
    data.portraitUrl = [info objectForKey:@"avatar"];
    return data;
}
- (void)getMoreFromNetWork
{
    [_refrehsTableView didFinishedLoadingTableViewData];
    //    [RequestManager getCommentWithSourceType:type andSourceID:sourceId page:(_dataSourceArray.count / 20 + 1) success:^(NSString *response) {
    //        NSArray * array = [[response JSONValue] objectForKey:@"comments"];
    //        _isLoadingMax = !array.count;
    //        [self addDataSourceWithArray:array];
    //        [_refrehsTableView didFinishedLoadingTableViewData];
    //    } failure:^(NSString *error) {
    //        [self showPopAlerViewRatherThentasView:NO WithMes:error];
    //        [_refrehsTableView didFinishedLoadingTableViewData];
    //    }];
}

#pragma mark -tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSourceArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataSourceArray.count){
        CommentCellDeteSource * source = [_dataSourceArray objectAtIndex:indexPath.row];
        return [source cellHeigth];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentify = @"CELL";
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.delegate = self;
    }
    if (indexPath.row < _dataSourceArray.count)
        cell.dataSource = [_dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark Action
- (void)backButtonClick:(id)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    }
}

- (void)commentCell:(CommentCell *)cell clickPortrait:(id)sender
{
    //    [self.navigationController pushViewController:[[PhotoWallController alloc] initWithOwnerID:[[cell dataSource] userId] isRootController:NO] animated:YES];
}
- (void)makeCommentView:(MakeCommentView *)view commentClick:(UIButton *)button
{
    [self commetButtonClick:button];
}
@end
