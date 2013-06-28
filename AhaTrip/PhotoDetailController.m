//
//  PhotoDetailController.m
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PhotoDetailController.h"

@implementation PhotoDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addScrollView];
    [self addPageController];
//    [self.view addSubview:[[PhotoDetailView alloc] initWithFrame:self.view.bounds controller:self imageInfo:nil]];
}
- (void)addScrollView
{
    _scrollView  = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    [self addScrollviewContent];
    
}
- (void)addPageController
{
    _pageControll = [[SMPageControl alloc] initWithFrame:CGRectMake(110, _scrollView.bounds.size.height - 35, 100, 40)];
    _pageControll.backgroundColor = [UIColor clearColor];
    _pageControll.currentPage = 0;
    _pageControll.numberOfPages = 4;
    [_pageControll setIndicatorMargin:2];
    [_pageControll setIndicatorDiameter:5];
    [_pageControll setPageIndicatorImage:[UIImage imageNamed:@"pageDot.png"]];
    [_pageControll setCurrentPageIndicatorImage:[UIImage imageNamed:@"currentPageDot.png"]];
    [_pageControll setUserInteractionEnabled:NO];
    [self.view addSubview:_pageControll];
    [self  playViewAnimation];
}
- (void)addScrollviewContent
{
    CGRect rect = self.view.bounds;
    for (int i = 0; i < 4; i++) {
        rect.origin.x = rect.size.width * i;
        PhotoDetailView * view = [[PhotoDetailView alloc] initWithFrame:rect controller:self imageInfo:nil];
        view.tag = i + 1000;
        [_scrollView addSubview:view];
    }
    _scrollView.contentSize = CGSizeMake(rect.size.width * 4, rect.size.height);
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollView]) {
        NSInteger curPage = floorf(([_scrollView contentOffset].x+ 161) / _scrollView.bounds.size.width);
        _pageControll.currentPage = curPage;
    }
    [self  playViewAnimation];
}
- (void)playViewAnimation
{
    NSInteger curPage = floorf(([_scrollView contentOffset].x+ 161) / _scrollView.bounds.size.width);
    for (int i = 0; i <_scrollView.subviews.count; i++) {
        PhotoDetailView * view = (PhotoDetailView *)[_scrollView viewWithTag:i + 1000];
        if (i == curPage) {
            [view startBgAnimation];
        }else{
            [view stopAnimation];
        }
    }
}
@end
