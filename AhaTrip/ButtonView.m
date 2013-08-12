//
//  ButtonView.m
//  GHSidebarNav
//
//  Created by tagux imac04 on 13-1-6.
//
//

#import "ButtonView.h"

@implementation ButtonView
@synthesize btn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addMyButton];
    }
    return self;
}
-(void)addMyButton{
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.btn setShowsTouchWhenHighlighted:YES];
    [self addSubview:self.btn];
}


@end
