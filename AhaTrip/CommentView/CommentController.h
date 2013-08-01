//
//  CommentController.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentCell.h"
#import "MakeCommentView.h"
#import "EGRefreshTableView.h"

@interface CommentController : UIViewController<UITableViewDataSource,EGRefreshTableViewDelegate,CommentCellDelegate,MakeCommentViewDelegate>
{
    EGRefreshTableView * _refrehsTableView;
    UIImageView * _myBgView;
    UIImage * _blurImgage;
    NSMutableArray * _dataSourceArray;
    MakeCommentView * commentView;
    NSInteger _findsID;
    NSDictionary * _userInfo;
    BOOL _isSending;
}
- (id)initWithBgImage:(UIImage*)image findsID:(NSInteger)findsID;
- (NSInteger)findsID;
@end
