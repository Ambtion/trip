//
//  CountLabel.m
//  SohuCloudPics
//
//  Created by sohu on 13-1-23.
//
//

#import "CountLabel.h"
#define ICONWIDTH 22

@implementation CountLabel
- (id)initIconLabeWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImage * bgImage = [[UIImage imageNamed:@"mes_Countbg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(11.f, 11.f, 11.f, 11.f)];
        _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        _bgImageView.backgroundColor = [UIColor redColor];
        _bgImageView.frame = self.bounds;
        [self addSubview:_bgImageView];
        return self;
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"LabelIcon.png"];
        _iconImageView.frame = CGRectMake(0, 0, ICONWIDTH, ICONWIDTH);
        [self addSubview:_iconImageView];
        
        _baseLabel = [[UILabel alloc] initWithFrame:CGRectMake(ICONWIDTH, 0, self.bounds.size.width - ICONWIDTH, self.bounds.size.height)];
        _baseLabel.backgroundColor = [UIColor clearColor];
        _baseLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_baseLabel];
        isIconModel = YES;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat offset = self.frame.size.height/2.f;
        UIImage * bgImage = [[UIImage imageNamed:@"mes_Countbg.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(offset, offset, offset, offset)];
        _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        _bgImageView.backgroundColor = [UIColor clearColor];
        _bgImageView.frame = self.bounds;
        _baseLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _baseLabel.backgroundColor = [UIColor clearColor];
        _baseLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:_bgImageView];
        [self addSubview:_baseLabel];
        isIconModel = NO;
    }
    return self;
}

#pragma mark
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _bgImageView.frame = self.bounds;
    _baseLabel.frame = self.bounds;
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [_baseLabel setFont:font];
}
- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:[UIColor clearColor]];
    [_baseLabel setTextColor:textColor];
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
}
- (void)setText:(NSString *)text
{
    [_baseLabel setText:text];
    [self sizeToFit];
}
- (void)sizeToFit
{
    if (isIconModel) {
        [_baseLabel sizeToFit];
        CGRect rect = _baseLabel.frame;
        self.frame = [self getRectwithWidth:_baseLabel.frame.size.width andHeigth:_baseLabel.frame.size.height];
        _baseLabel.frame  = rect;

    }else{
        [_baseLabel sizeToFit];
        CGFloat actaulWidth = _baseLabel.frame.size.width > self.frame.size.height ? _baseLabel.frame.size.width + 10: self.frame.size.height ;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, actaulWidth, _baseLabel.frame.size.height);
    }
    
}
- (CGRect)getRectwithWidth:(CGFloat)width andHeigth:(CGFloat)heigth
{
    width = width > self.frame.size.width ? width+10 :self.frame.size.height;
    CGPoint endPoint = CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
    return CGRectMake(endPoint.x - width -ICONWIDTH  - 5, endPoint.y - heigth, width + ICONWIDTH + 5, heigth);
}
@end
