//
//  PhotoDetailController.m
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PhotoDetailController.h"
#import "HomePageController.h"

@implementation PhotoDetailController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addScrollView];
    [self addPageController];
    [self addBackButton];
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

#pragma mark BackButton
- (void)addBackButton
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(7, 7, 33, 33);
    [backButton setImage:[UIImage imageNamed:@"back_Button.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    _portraitImage = [[PortraitView alloc] initWithFrame:CGRectMake(320 - 47, 7, 40, 40)];
    _portraitImage.imageView.image = [UIImage imageNamed:@"testImage.png"];
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesutre:)];
    [_portraitImage addGestureRecognizer:ges];
    [_portraitImage setUserInteractionEnabled:YES];
    [self.view addSubview:_portraitImage];
}
- (void)tapGesutre:(id)gesture
{
    [self.navigationController pushViewController:[[HomePageController alloc] initAsRootViewController:NO] animated:YES];
}
- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
