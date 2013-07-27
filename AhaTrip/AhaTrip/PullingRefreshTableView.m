//
//  PullingRefreshTableView.m
//  PullingTableView
//
//  Created by luo danal on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PullingRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>

@interface PullingRefreshTableView ()
- (void)scrollToNextPage;
@end

#define kLeftMargin 0

@implementation PullingRefreshTableView
@synthesize pullingDelegate = _pullingDelegate;
@synthesize reachedTheEnd   = _reachedTheEnd;
@synthesize headerOnly      = _headerOnly;
@synthesize footerOnly      = _footerOnly;
@synthesize autoScrollToNextPage;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        CGRect rect = CGRectMake(kLeftMargin, 0 - frame.size.height, frame.size.width - kLeftMargin, frame.size.height);
        _headerView = [[LoadingView alloc] initWithFrame:rect atTop:YES];
        _headerView.atTop = YES;
        [self addSubview:_headerView];
        
        rect = CGRectMake(kLeftMargin, frame.size.height, frame.size.width - kLeftMargin, frame.size.height);
        _footerView = [[LoadingView alloc] initWithFrame:rect atTop:NO];
        _footerView.atTop = NO;
        [self addSubview:_footerView];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate {
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.pullingDelegate = aPullingDelegate;
    }
    return self;
}

- (void)setReachedTheEnd:(BOOL)reachedTheEnd{
    _reachedTheEnd = reachedTheEnd;
    if (_reachedTheEnd){
        _footerView.state = kPRStateHitTheEnd;
    } else {
        _footerView.state = kPRStateNormal;
    }
}

- (void)setHeaderOnly:(BOOL)headerOnly{
    _headerOnly = headerOnly;
    _footerView.hidden = _headerOnly;
}

- (void)setFooterOnly:(BOOL)footerOnly
{
    _footerOnly = footerOnly;
    _headerView.hidden = _footerOnly;
}
- (void)dealloc
{
    [super dealloc];  
//    [self removeObserver:self forKeyPath:@"contentSize"];
}
#pragma mark - Scroll methods

- (void)scrollToNextPage {
    float h = self.frame.size.height;
    float y = self.contentOffset.y + h;
    y = y > self.contentSize.height ? self.contentSize.height : y;
    
    [UIView animateWithDuration:.7f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.contentOffset = CGPointMake(0, y);
                     }
                     completion:^(BOOL bl){
                     }];
}

- (void)tableViewDidScroll:(UIScrollView *)scrollView {
    
    if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading) {
        return;
    }
    
    CGPoint offset = scrollView.contentOffset;
    CGSize size = scrollView.frame.size;
    CGSize contentSize = scrollView.contentSize;
    
    float yMargin;
    if(contentSize.height>size.height){
        yMargin = offset.y + size.height - contentSize.height;
    }else{
        yMargin = offset.y;
    }
    
    
    
    if (offset.y < -kPROffsetY) {   //header totally appeard
        _headerView.state = kPRStatePulling;
    } else if (offset.y > -kPROffsetY && offset.y < 0){ //header part appeared
        _headerView.state = kPRStateNormal;
        
    } else if ( yMargin > kPROffsetY){  //footer totally appeared
        
        if (_footerView.state != kPRStateHitTheEnd) {
            _footerView.state = kPRStatePulling;
        }
    } else if ( yMargin < kPROffsetY && yMargin > 0) {//footer part appeared
        
        if (_footerView.state != kPRStateHitTheEnd) {
            _footerView.state = kPRStateNormal;
        }
    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView {
    
    //    CGPoint offset = scrollView.contentOffset;
    //    CGSize size = scrollView.frame.size;
    //    CGSize contentSize = scrollView.contentSize;
    if (_headerView.state == kPRStateLoading || _footerView.state == kPRStateLoading) {
        return;
    }
    if (_headerView.state == kPRStatePulling) {
        
        if(self.footerOnly) return;
        _isFooterInAction = NO;
        _headerView.state = kPRStateLoading;
        
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(kPROffsetY, 0, 0, 0);
        }];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
            [self performSelector:@selector(doActionRefreshing) withObject:nil afterDelay:0.6];
        }
    } else if (_footerView.state == kPRStatePulling) {
        //    } else  if (offset.y + size.height - contentSize.height > kPROffsetY){
        if (self.reachedTheEnd || self.headerOnly) {
            return;
        }
        _isFooterInAction = YES;
        _footerView.state = kPRStateLoading;
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, kPROffsetY, 0);
        }];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
            //            [_pullingDelegate pullingTableViewDidStartLoading:self];
            [self performSelector:@selector(doActionLoading) withObject:nil afterDelay:0.1];
            
        }
    }
}

-(void)doActionRefreshing{
    [_pullingDelegate pullingTableViewDidStartRefreshing:self];
}

-(void)doActionLoading{
    
    [_pullingDelegate pullingTableViewDidStartLoading:self];
}


- (void)tableViewDidFinishedLoading {
    [self tableViewDidFinishedLoadingWithMessage:nil];
}

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg{
    
    //    if (_headerView.state == kPRStateLoading) {
    if (_headerView.loading) {
        _headerView.loading = NO;
        [_headerView setState:kPRStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewRefreshingFinishedDate)]) {
            date = [_pullingDelegate pullingTableViewRefreshingFinishedDate];
        }
        [_headerView updateRefreshDate:date];
        [UIView animateWithDuration:kPRAnimationDuration*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }
        }];
    }
    //    if (_footerView.state == kPRStateLoading) {
    else if (_footerView.loading) {
        _footerView.loading = NO;
        [_footerView setState:kPRStateNormal animated:NO];
        NSDate *date = [NSDate date];
        if (_pullingDelegate && [_pullingDelegate respondsToSelector:@selector(pullingTableViewLoadingFinishedDate)]) {
            date = [_pullingDelegate pullingTableViewRefreshingFinishedDate];
        }
        [_footerView updateRefreshDate:date];
        
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } completion:^(BOOL bl){
            if (msg != nil && ![msg isEqualToString:@""]) {
                [self flashMessage:msg];
            }
        }];
    }
}

- (void)flashMessage:(NSString *)msg{
    //Show message
    __block CGRect rect = CGRectMake(25, self.contentOffset.y - 20, self.bounds.size.width - 50, 70);
    
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.frame = rect;
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.font = [UIFont systemFontOfSize:30.f];
        _msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _msgLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
        _msgLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_msgLabel];
    }
    _msgLabel.text = msg;
    
    rect.origin.y += 20;
    [UIView animateWithDuration:.4f animations:^{
        _msgLabel.frame = rect;
    } completion:^(BOOL finished){
        rect.origin.y -= 20;
        [UIView animateWithDuration:.4f delay:1.2f options:UIViewAnimationOptionCurveLinear animations:^{
            _msgLabel.frame = rect;
        } completion:^(BOOL finished){
            [_msgLabel removeFromSuperview];
            _msgLabel = nil;
        }];
    }];
}

- (void)launchRefreshing
{
    [self setContentOffset:CGPointMake(0,0) animated:NO];
    [UIView animateWithDuration:kPRAnimationDuration animations:^{
        self.contentOffset = CGPointMake(0, -kPROffsetY-1);
    } completion:^(BOOL bl){
        [self tableViewDidEndDragging:self];
    }];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGRect frame = _footerView.frame;
    CGSize contentSize = self.contentSize;
    frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height : contentSize.height;
    _footerView.frame = frame;
    if (self.autoScrollToNextPage && _isFooterInAction) {
        [self scrollToNextPage];
        _isFooterInAction = NO;
    } else if (_isFooterInAction) {
        CGPoint offset = self.contentOffset;
        //        offset.y += 44.f;
        self.contentOffset = offset;
    }
}

@end

