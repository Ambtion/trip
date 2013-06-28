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

#define TIMEOFFSET 10.f

@implementation PhotoDetailView

- (id)initWithFrame:(CGRect)frame  controller:(UIViewController *)controller imageInfo:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        _controller = controller;
        self.clipsToBounds = YES;
        [self addBgImageView];
        [self addDetailView];
        [self addLikesButton];
        [self addComentButton];
//        [self startBgAnimation];
    }
    return self;
}
- (void)addBgImageView
{
    CGFloat maxWidth = MAX(self.frame.size.width, self.frame.size.height);
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,maxWidth, maxWidth)];
    _bgImageView.backgroundColor = [UIColor grayColor];
    _originalImage = [UIImage imageNamed:@"test2.jpg"];
    _bgImageView.image = _originalImage;
    [self addSubview:_bgImageView];
}

- (void)addDetailView
{
    _detailIcon = [[DetailTextIcon alloc] initWithView:self];
    _detailIcon.delegate = self;
    DesInfoViewDataSource * source = [[DesInfoViewDataSource alloc] init];
    source.averConsume = @"200美元";
    source.businessTime = @"5:00--8:00";
    source.netHasWifi = @"是";
    source.sortImage = [UIImage imageNamed:@"1.png"];
    source.userName = @"奈良のIceCream";
    source.desString = @"没有描述啊,没描述,我就是不描述,你就没描述,没描述啊没描述,没人给你描述啊,没有描述啊,没描述,我就是不描述,你就没描述,没描,没有描述啊,没描述,我就是不描述,你就没描述,没描";
    source.location  = @"我在那我怎么知道";
    _detailIcon.datasoure = source;
}
- (void)detailTextIconHiddenAnimationDidFinished:(DetailTextIcon *)icon
{
    UIImage * toImage = [UIImage imageNamed:@"test2.jpg"];
    [self changeToImageWithAnimation:toImage];
}
- (void)detailTextIconShowAnimationDidFinished:(DetailTextIcon *)icon
{
    
    [self changeToImageWithAnimation:[self getBlurImage]];
}
- (void)changeToImageWithAnimation:(UIImage *)toImage
{
    [UIView transitionWithView:_bgImageView.superview
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _bgImageView.image = toImage;
                    } completion:nil];
}
- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
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
        _blurImage = [self blurryImage:_bgImageView.image withBlurLevel:0.1];
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
    label.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:35];
}

#pragma mark - AddTimer
- (void)startBgAnimation
{
    [self moveToLeft];
    timer = [NSTimer timerWithTimeInterval:TIMEOFFSET target:self selector:@selector(movePicAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)stopAnimation
{
    [timer invalidate];
    CGRect rect = _bgImageView.frame;
    rect.origin.x = 0;
    _bgImageView.frame = rect;
}
- (void)movePicAnimation
{
    CGRect rect = _bgImageView.frame;
    if (rect.origin.x == 0) {
        [self moveToLeft];
    }else{
        [self moveToRigth];
    }
}
- (void)moveToRigth
{
    if (isAnimation) return;
    isAnimation = YES;
    CGRect rect = _bgImageView.frame;
    rect.origin.x = 0.f;
    [UIView animateWithDuration:TIMEOFFSET delay:0.f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _bgImageView.frame = rect;
    } completion:^(BOOL finished) {
        isAnimation = NO;
    }];
}
- (void)moveToLeft
{
    if (isAnimation) return;
    isAnimation = YES;
    CGRect rect = _bgImageView.frame;
    rect.origin.x = self.frame.size.width -  _bgImageView.frame.size.width ;
    [UIView animateWithDuration:TIMEOFFSET delay:0.f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _bgImageView.frame = rect;
    } completion:^(BOOL finished) {
        isAnimation = NO;
    }];
}
@end
