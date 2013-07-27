//
//  PhotoDetailView.m
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PhotoDetailView.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import "CommentController.h"
#import "UIImageView+WebCache.h"

#define TIMEOFFSET 0.01f
#define MOVEOFFSET 0.2f

@implementation PhotoDetailViewDataSource
@synthesize dataSource = _dataSource;
@synthesize imageUrl = _imageUrl;
@end

@implementation PhotoDetailView
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame  controller:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        _controller = controller;
        self.clipsToBounds = YES;
        [self addBgImageView];
        [self addDetailView];
        [self addLikesButton];
        [self addComentButton];
    }
    return self;
}
- (void)addBgImageView
{
    CGFloat maxWidth = MAX(self.frame.size.width, self.frame.size.height);
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,maxWidth, maxWidth)];
    _bgImageView.backgroundColor = [UIColor grayColor];
//    _originalImage = [UIImage imageNamed:@"test2.jpg"];
    _bgImageView.image = _originalImage;
    [self addSubview:_bgImageView];
}

- (void)addDetailView
{
    _detailIcon = [[DetailTextIcon alloc] initWithView:self];
    _detailIcon.delegate = self;
}
- (void)detailTextIconHiddenAnimationDidFinished:(DetailTextIcon *)icon
{
    DLog(@"%@",_originalImage);
    [self changeToImageWithAnimation:_originalImage];
}
- (void)detailTextIconShowAnimationDidFinished:(DetailTextIcon *)icon
{
    _originalImage = [_bgImageView image];
    [self changeToImageWithAnimation:[self getBlurImage]];
}
- (void)setDataSource:(PhotoDetailViewDataSource *)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        _detailIcon.datasoure = dataSource.dataSource;
 
        [_bgImageView setImageWithURL:[NSURL URLWithString:_dataSource.imageUrl] placeholderImage:[UIImage imageNamed:@"test2.jpg"] success:^(UIImage *image) {
        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark MoveAction
- (void)changeToImageWithAnimation:(UIImage *)toImage
{
    [_timer invalidate];
    [UIView transitionWithView:_bgImageView.superview duration:0.3 options:
                    UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        _bgImageView.image = toImage;
                    } completion:^(BOOL finished) {
                        _timer = [NSTimer timerWithTimeInterval:TIMEOFFSET target:self selector:@selector(movePicAnimation) userInfo:nil repeats:YES];
                        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }];
}
#pragma mark Like
- (void)addLikesButton
{
    _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, self.bounds.size.height - 65, 80,35)];
    [self setCountLabels:_likeLabel];
    [self addSubview:_likeLabel];
    _likeButton = [[UIButton  alloc] initWithFrame:CGRectMake(_likeLabel.frame.size.width + _likeLabel.frame.origin.x + 5, _likeLabel.frame.origin.y + _likeLabel.frame.size.height - 22, 24, 22)];
    [_likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setLikeState];
    [self addSubview:_likeButton];
}
- (void)setLikeState
{
    [_likeButton setImage:[UIImage imageNamed:@"details_button_like.png"] forState:UIControlStateNormal];
    _likeLabel.text = @"45";
}
- (void)likeButtonClick:(UIButton *)button
{
    DLog();
}
#pragma mark - comment
- (void)addComentButton
{
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width + 20, self.bounds.size.height - 65, 80,35)];
    [self setCountLabels:_commentLabel];
    [self addSubview:_commentLabel];
    UIButton * commentButton = [[UIButton  alloc] initWithFrame:CGRectMake(_commentLabel.frame.size.width + _commentLabel.frame.origin.x + 5, _commentLabel.frame.origin.y + _commentLabel.frame.size.height - 23, 23, 23)];
    _commentLabel.text = @"45";
    [commentButton setImage:[UIImage imageNamed:@"details_button_comment.png"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentButton];
}
- (void)commentButtonClick:(UIButton *)button
{
    [self showCommentViewControllerWithImage:[self getBlurImage]];
}
- (UIImage *)getBlurImage
{
    if (!_blurImage)
        _blurImage = [_bgImageView blurryImage:_bgImageView.image withBlurLevel:0.1];
    return _blurImage;
}
- (void)showCommentViewControllerWithImage:(UIImage *)image
{
    [_controller presentModalViewController:[[CommentController alloc] initWithBgImage:[self getBlurImage]] animated:YES];
}

- (void)setCountLabels:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(1, 1);
    label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    label.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35];
}

#pragma mark - AddTimer
- (void)startBgAnimation
{
    [self movePicAnimation];
    _timer = [NSTimer timerWithTimeInterval:TIMEOFFSET target:self selector:@selector(movePicAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
}
- (void)stopAnimation
{
    [_timer invalidate];
    _isMoveToRight = YES;
    CGRect rect = _bgImageView.frame;
    rect.origin.x = 0;
    _bgImageView.frame = rect;
}
- (void)movePicAnimation
{
    if(_isMoveToRight)
        [self moveToRigth];
    else
        [self moveToLeft];
}
- (void)moveToRigth
{
    CGRect rect = _bgImageView.frame;
    rect.origin.x += MOVEOFFSET;
    if (rect.origin.x >= 0){
        rect.origin.x = 0;
        _isMoveToRight = NO;
    }
    [self moveWithRect:rect];
}
- (void)moveToLeft
{
    CGRect rect = _bgImageView.frame;
    rect.origin.x -=MOVEOFFSET;
    if (rect.origin.x <= self.frame.size.width - rect.size.width){
        rect.origin.x = self.frame.size.width - rect.size.width;
        _isMoveToRight = YES;
    }
    [self moveWithRect:rect];
}

- (void)moveWithRect:(CGRect)rect
{
    if (isAnimation) return;
    isAnimation = YES;
    [UIView animateWithDuration:TIMEOFFSET delay:0.f options: UIViewAnimationOptionCurveEaseInOut animations:^{
        _bgImageView.frame = rect;
    } completion:^(BOOL finished) {
        isAnimation = NO;
    }];
}
@end
