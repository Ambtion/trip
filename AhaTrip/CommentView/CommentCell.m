//
//  CommentCell.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-5-2.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"

#define TEXTCOLOR   [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:1.f]
#define TEXTFONT    [UIFont systemFontOfSize:16]
#define OFFSETY     10.f
@implementation CommentCellDeteSource
@synthesize userId,portraitUrl,userName,commentStr,commentID,toUserName;

- (CGFloat)cellHeigth
{
    NSString * str = nil;
    if (self.toUserName && ![self.toUserName isEqualToString:@""]) {
        str = [NSString stringWithFormat:@"%@回复%@ : %@",self.userName,self.toUserName,self.commentStr];
    }else{  
        str = [NSString stringWithFormat:@"%@ : %@",self.userName,self.commentStr];

    }
            DLog(@"%@",str);
    CGSize size = [str sizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(220, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height + 6, 41) +  6.f + OFFSETY;
}

@end
@implementation CommentCell
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor blackColor];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews
{
    
    porViews = [[PortraitView alloc] initWithFrame:CGRectMake(20, 6 + OFFSETY, 41, 41)];
    porViews.clipsToBounds = YES;
    [porViews setUserInteractionEnabled:YES];
    [self.contentView addSubview:porViews];
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleUserPortraitTap:) ];
    [porViews addGestureRecognizer:ges];
    
    commentbgView = [[UIView alloc] initWithFrame:CGRectMake(61, 6 + OFFSETY, 240, 0)];
    commentbgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    [self.contentView addSubview:commentbgView];
    UITapGestureRecognizer * ges_c = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentBgClick:)];
    [commentbgView addGestureRecognizer:ges_c];
    [commentbgView setUserInteractionEnabled:YES];
    _myDetailTextView = [[DetailTextView alloc] initWithFrame:CGRectMake(61 + 8, 9 + OFFSETY, 220, 20)];
    _myDetailTextView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_myDetailTextView];
}

- (CommentCellDeteSource *)dataSource
{
    return _dataSource;
}

- (void)setDataSource:(CommentCellDeteSource *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self updateViews];
    }
}
- (void)updateViews
{
    [porViews.imageView setImageWithURL:[NSURL URLWithString:_dataSource.portraitUrl] placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    NSString * str = nil;
    NSArray * array = nil;
    if (_dataSource.toUserName && ![_dataSource.toUserName isEqualToString:@""]) {
        str = [NSString stringWithFormat:@"%@回复%@ : %@",_dataSource.userName,_dataSource.toUserName,_dataSource.commentStr];
        array = [NSArray arrayWithObjects:_dataSource.userName,[NSString stringWithFormat:@"%@ ",_dataSource.toUserName],@":",nil];
        
    }else{
        str = [NSString stringWithFormat:@"%@ : %@",_dataSource.userName,_dataSource.commentStr];
        array = [NSArray arrayWithObjects:_dataSource.userName,@":",nil];
    }
    DLog(@"LLL::%@",str);
    CGSize size = [str sizeWithFont:TEXTFONT constrainedToSize:CGSizeMake(220, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rect = _myDetailTextView.frame;
    rect.size.width = size.width;
    rect.size.height = size.height;
    _myDetailTextView.frame = rect;
    [_myDetailTextView setText:str WithFont:TEXTFONT AndColor:TEXTCOLOR];
    [_myDetailTextView setKeyWordTextArray:array WithFont:TEXTFONT AndColor:[UIColor colorWithRed:2/255.f green:94.f/255 blue:154.f/255 alpha:1]];
//    [_myDetailTextView setKeyWordTextArray:array WithFont: AndColor:[UIColor redColor]];
    CGRect bgRect= commentbgView.frame;
    bgRect.size.height = MAX(size.height + 6 , porViews.frame.size.height);
    commentbgView.frame = bgRect;
}
- (void)handleUserPortraitTap:(UIGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(commentCell:clickPortrait:)])
        [_delegate commentCell:self clickPortrait:gesture];
}
- (void)commentBgClick:(UIGestureRecognizer *)gesture
{
    if ([_delegate respondsToSelector:@selector(commentCell:clickComment:)])
        [_delegate commentCell:self clickComment:gesture];
}
@end
