//
//  CommentCell.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"
#import "DetailTextView.h"

@interface CommentCellDeteSource : NSObject
@property(nonatomic,strong)NSString * userId;
@property(nonatomic,assign)NSInteger  commentID;
@property(nonatomic,strong)NSString * portraitUrl;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,strong)NSString * toUserName;
@property(nonatomic,strong)NSString * commentStr;
- (CGFloat)cellHeigth;

@end
@class CommentCell;
@protocol CommentCellDelegate <NSObject>
- (void)commentCell:(CommentCell *)cell clickPortrait:(id)sender;
- (void)commentCell:(CommentCell *)cell clickComment:(id)sender;

@end
@interface CommentCell : UITableViewCell
{
    PortraitView * porViews;
    UILabel * nameLabel;
    UILabel * commentLabel;
    UIView * commentbgView;
    CommentCellDeteSource * _dataSource;
    DetailTextView * _myDetailTextView;
}
@property(strong,nonatomic)CommentCellDeteSource * dataSource;
@property(weak,nonatomic)id<CommentCellDelegate> delegate;
@end
