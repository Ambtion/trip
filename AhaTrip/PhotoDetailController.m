//
//  PhotoDetailController.m
//  AhaTrip
//
//  Created by sohu on 13-6-27.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import "PhotoDetailController.h"
#import "HomePageController.h"
#import "RequestManager.h"
#import "UIImageView+WebCache.h"

@implementation PhotoDetailController
- (id)initWithTitleId:(NSString *)titleId
{
    self = [super init];
    if (self) {
        _titleId = titleId;
    }
    return self;
}
#pragma mark Data
- (void)getDataSource
{
    [self waitForMomentsWithTitle:@"加载中" withView:self.view];
    [RequestManager getTitleImagesWithId:_titleId success:^(NSString *response) {
        _dataInfo = [[response JSONValue] objectForKey:@"finding"];
        [self addScrollviewConten];
        [self stopWaitProgressView:nil];
    } failure:^(NSString *error) {
        [self stopWaitProgressView:nil];
    }];
}
#pragma mark View
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    [self addScrollView];
    [self addPageController];
    [self addBackButton];
    [self getDataSource];
}

- (void)addScrollView
{
    _scrollView  = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
}
- (void)addPageController
{
    _pageControll = [[SMPageControl alloc] initWithFrame:CGRectMake(110, _scrollView.bounds.size.height - 35, 100, 40)];
    _pageControll.backgroundColor = [UIColor clearColor];
    _pageControll.currentPage = 0;
    _pageControll.numberOfPages = 0;
    [_pageControll setIndicatorMargin:2];
    [_pageControll setIndicatorDiameter:5];
    [_pageControll setPageIndicatorImage:[UIImage imageNamed:@"pageDot.png"]];
    [_pageControll setCurrentPageIndicatorImage:[UIImage imageNamed:@"currentPageDot.png"]];
    [_pageControll setUserInteractionEnabled:NO];
    [self.view addSubview:_pageControll];
//    [self  playViewAnimation];
}
- (void)addScrollviewConten
{
    DLog(@"%@",_dataInfo);
    CGRect rect = self.view.bounds;
    [self serUsrInfo];
    _findsId  = [[_dataInfo objectForKey:@"id"] intValue];
    DesInfoViewDataSource * desInfo = [self getDesSouce];
    NSArray * photos = [_dataInfo objectForKey:@"photos"];
    for (int i = 0; i < photos.count; i++) {
        NSDictionary * photoInfo = [photos objectAtIndex:i];
        rect.origin.x = rect.size.width * i;
        PhotoDetailView * view = [[PhotoDetailView alloc] initWithFrame:rect controller:self];
        PhotoDetailViewDataSource * photoSource = [[PhotoDetailViewDataSource alloc] init];
        photoSource.dataSource = desInfo;
        photoSource.islikedAddress = &isLiked;
        photoSource.likeCountAddress = &likeCount;
        photoSource.commentCountAddress = &commentCount;
        photoSource.imageUrl = [photoInfo objectForKey:@"photo"];
        photoSource.findingId = _findsId;
        view.dataSource = photoSource;
        view.tag = i + 1000;
        [_scrollView addSubview:view];
    }
    _pageControll.numberOfPages = photos.count;
    [_pageControll setHidden:[photos count] <= 1];
    _scrollView.contentSize = CGSizeMake(rect.size.width * photos.count, rect.size.height);
    [_scrollView setContentOffset:CGPointZero];
    [self scrollViewDidScroll:_scrollView];
}

- (void)setLikeAndCommentDataSourceWithInfo:(NSDictionary *)info
{
    isLiked = NO;
    commentCount = [[info objectForKey:@"comments_count"] intValue];
    likeCount =  [[info objectForKey:@"favorite_count"] intValue];
}

- (void)serUsrInfo
{
    DLog(@"%@",_dataInfo);
    NSDictionary * userInfo = [_dataInfo objectForKey:@"user"];
    [_portraitImage.imageView setImageWithURL:[NSURL URLWithString:[userInfo objectForKey:@"photo_thumb"]]placeholderImage:[UIImage imageNamed:@"avatar.png"]];
    _nameLabel.text = [userInfo objectForKey:@"username"];
    [self setLikeAndCommentDataSourceWithInfo:_dataInfo];
}
- (DesInfoViewDataSource *)getDesSouce
{
    DesInfoViewDataSource * source = [[DesInfoViewDataSource alloc] init];
    source.userName = [NSString stringWithFormat:@"%@-%@",[_dataInfo objectForKey:@"country"],[_dataInfo objectForKey:@"city"]];
    source.desString = [_dataInfo objectForKey:@"description"];
    source.location = [_dataInfo objectForKey:@"position"];
    source.averConsume = [_dataInfo objectForKey:@"price"];
    source.netHasWifi = [_dataInfo objectForKey:@"wifi"];
    source.sortImage = [UIImage imageNamed:[self getCateryImage:[[_dataInfo objectForKey:@"category_id"] intValue] - 1]];
    return source;
}

#pragma mark BackButton
- (void)addBackButton
{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(12, 10, 40, 40);
    [_backButton setContentMode:UIViewContentModeScaleAspectFit];
    [_backButton setImage:[UIImage imageNamed:@"back_Button.png"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    _portraitImage = [[PortraitView alloc] initWithFrame:CGRectMake(320 - 52, 10, 40, 40)];
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesutre:)];
    _portraitImage.layer.shadowColor = [[UIColor blackColor] CGColor];
    _portraitImage.layer.shadowOpacity = 0.75;
    _portraitImage.layer.shadowOffset = CGSizeMake(4, 4);
    _portraitImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    _portraitImage.layer.borderWidth = 2.f;
    [_portraitImage addGestureRecognizer:ges];
    [_portraitImage setUserInteractionEnabled:YES];
    [self.view addSubview:_portraitImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( _portraitImage.frame.origin.x - 200, _portraitImage.frame.size.height + _portraitImage.frame.origin.y, _portraitImage.frame.size.width + 200, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = UITextAlignmentRight;
    _nameLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    _nameLabel.shadowOffset = CGSizeMake(1, 1);
    [self.view addSubview:_nameLabel];
}
- (void)setBackFront
{
    [self.view bringSubviewToFront:_backButton];
    [self.view bringSubviewToFront:_portraitImage];
}
- (void)tapGesutre:(id)gesture
{
    NSDictionary * userInfo = [_dataInfo objectForKey:@"user"];
    [self.navigationController pushViewController:[[HomePageController alloc] initAsRootViewController:NO withUserId:[userInfo objectForKey:@"id"]] animated:YES];
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
