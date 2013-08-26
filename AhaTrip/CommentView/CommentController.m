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
- (NSInteger)findsID
{
    return _findsID;
}
- (id)initWithBgImage:(UIImage*)image findsID:(NSInteger)findsID
{
    self = [super init];
    if (self) {
        _blurImgage = image;
        _findsID = findsID;
        _commentId = 0;
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
    [self getUserInfo];
}
- (void)getUserInfo
{
    [RequestManager getUserInfoWithUserId:[LoginStateManager currentUserId] success:^(NSString *response) {
        _userInfo = [[response JSONValue] objectForKey:@"user"];
    } failure:^(NSString *error) {
       
    }];
}
- (void)addBgViewWithImage:(UIImage *)image
{
    CGFloat maxSize = MAX(CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
    _myBgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, maxSize, maxSize)];
    _myBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _myBgView.image = image;
    [self.view addSubview:_myBgView];
    _myBgView.center = CGPointMake(self.view.frame.size.width/2.f, self.view.frame.size.height/2.f);
}

- (void)addTableView
{
    _refrehsTableView = [[EGRefreshTableView alloc] initWithFrame:CGRectMake(0, 44 + 15, 320, self.view.bounds.size.height - 44 - 38 - 15) style:UITableViewStylePlain];
    _refrehsTableView.backgroundColor =  [UIColor clearColor];
    _refrehsTableView.pDelegate = self;
    _refrehsTableView.dataSource = self;
    _refrehsTableView.tableFooterView = nil;
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
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backButton setContentMode:UIViewContentModeScaleAspectFit];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"comment_back_button.png"] forState:UIControlStateNormal];
    backButton.center = CGPointMake(self.view.frame.size.width /2.f, backButton.center.y);
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
    if (_isSending) return;
    _isSending = YES;
    [RequestManager postComment:commentView.textView.internalTextView.text WithFindingId:_findsID withCommentFatherId:_commentId success:^(NSString *response) {
        [_dataSourceArray insertObject:[self getCommentSoureWithComment:commentView.textView.internalTextView.text] atIndex:0];
        commentView.textView.internalTextView.text = nil;
        [commentView.textView resignFirstResponder];
        [_refrehsTableView reloadData];
        _isSending  = NO;
        DLog(@"%@",[response JSONValue]);
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [commentView.textView resignFirstResponder];
        _isSending  = NO;
    }];
}

- (CommentCellDeteSource *)getCommentSoureWithComment:(NSString *)comment
{
    //临时
    CommentCellDeteSource * dataSource = [[CommentCellDeteSource alloc] init];
    dataSource.portraitUrl = [_userInfo objectForKey:@"thumb"];
    dataSource.userName =[_userInfo objectForKey:@"username"];
    dataSource.commentID = _commentId;
    DLog(@"LLL:%@",_userInfo);
    if (_commentId)
        dataSource.toUserName = _toUserName;
    dataSource.userId = [NSString stringWithFormat:@"%d",[[_userInfo objectForKey:@"id"] intValue]];
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
    [RequestManager getCommentWithFindingId:_findsID start:0 count:20   success:^(NSString *response) {
        DLog(@"%@",[response JSONValue]);
        [_dataSourceArray removeAllObjects];
        [self addDataSourceWithArray:[[response JSONValue] objectForKey:@"comments"]];
    } failure:^(NSString *error) {
        [_refrehsTableView didFinishedLoadingTableViewData];
    }];
}
- (void)getMoreFromNetWork
{
    if (_dataSourceArray.count % 20) {
        [_refrehsTableView didFinishedLoadingTableViewData];
        return;
    }
    [RequestManager getCommentWithFindingId:_findsID start:_dataSourceArray.count count:20  success:^(NSString *response) {
        [self addDataSourceWithArray:[[response JSONValue] objectForKey:@"comments"]];
        
    } failure:^(NSString *error) {
        [_refrehsTableView didFinishedLoadingTableViewData];

    }];
}
- (void)addDataSourceWithArray:(NSArray *)array
{
    for (int i = array.count - 1; i >= 0; i--)
        [_dataSourceArray addObject:[self getCellDataSourceFromInfo:[array objectAtIndex:i]]];
    [_refrehsTableView reloadData];
    [_refrehsTableView didFinishedLoadingTableViewData];
}

- (CommentCellDeteSource *)getCellDataSourceFromInfo:(NSDictionary *)info
{
    
    CommentCellDeteSource * data = [[CommentCellDeteSource alloc] init];
    data.commentStr = [info objectForKey:@"content"];
    data.toUserName = [info objectForKey:@"to_user_name"];
    data.commentID = [[info objectForKey:@"id"] intValue];
    
    info = [info objectForKey:@"user"];
    data.userName = [info objectForKey:@"username"];
    data.userId = [NSString stringWithFormat:@"%@",[info objectForKey:@"id"]];
    data.portraitUrl = [info objectForKey:@"photo_thumb"];
    return data;
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
//    if (self.navigationController) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
//    }
}

- (void)commentCell:(CommentCell *)cell clickPortrait:(id)sender
{
    DLog(@"%@",self.navigationController);
    [self.navigationController pushViewController:[[HomePageController alloc] initAsRootViewController:NO withUserId:cell.dataSource.userId] animated:YES];
}
- (void)commentCell:(CommentCell *)cell clickComment:(id)sender
{
    _commentId = [cell.dataSource commentID];
    _toUserName = [cell.dataSource toUserName];
    [commentView.textView becomeFirstResponder];
}
- (void)makeCommentView:(MakeCommentView *)view commentClick:(UIButton *)button
{
    [self commetButtonClick:button];
}
@end
