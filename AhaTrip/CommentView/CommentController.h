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
}
- (id)initWithBgImage:(UIImage*)image;
@end
