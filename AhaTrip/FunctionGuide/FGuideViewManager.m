//
//  FGuideViewManager.m
//  AhaTrip
//
//  Created by sohu on 13-9-3.
//  Copyright (c) 2013年 ke. All rights reserved.
//


#import "FGuideViewManager.h"
static   NSString * _identify;

@implementation FGuideView
@synthesize delegate = _delegate;

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)tap:(id)sender
{
    DLog(@"%@",_delegate);
    if ([_delegate respondsToSelector:@selector(fguideViewdidDisAppear:)]) {
        [_delegate fguideViewdidDisAppear:self];
    }
    [self removeFromSuperview];
}
@end


@implementation FGuideViewManager

+ (void)showFGuideViewWithImageaArray:(NSArray *)array superController:(UIViewController *)controller
{
    _identify = [NSString stringWithFormat:@"__%@__%@",[controller class],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:_identify] boolValue] != YES) {
        FGuideViewManager * fgm =  [[FGuideViewManager alloc] initWitImageaArray:array superView:controller.view];
        [fgm addfguideView];
    }
}
- (id)initWitImageaArray:(NSArray *)array  superView:(UIView *)view
{
    self = [super initWithFrame:CGRectMake(0, 0, 320,[[UIScreen mainScreen] bounds].size.height - 20)];
    if (self) {
        _imageArray = [NSMutableArray arrayWithArray:array];
        _superView = view;
        [_superView addSubview:self];
    }
    return self;
}
- (void)addfguideView
{
    if (_imageArray.count) {
        FGuideView * view = [[FGuideView alloc] initWithImage:[UIImage imageNamed:[_imageArray  objectAtIndex:0]]];
        view.frame = self.bounds;
        view.delegate = self;
        [self addSubview:view];
        [_imageArray removeObjectAtIndex:0];
    }else{
        DLog(@"%@",_identify);
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:_identify];
        [self removeFromSuperview];
    }
}
- (void)fguideViewdidDisAppear:(FGuideView *)guideView
{
    DLog();
    [self addfguideView];
}
@end
