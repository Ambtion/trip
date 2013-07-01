//
//  HomeSegMent.h
//  SegMentView
//
//  Created by sohu on 13-7-1.
//  Copyright (c) 2013年 sohu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeSegMentItems;
@interface HomeSegMent : UIControl
{
    UIImageView * _bgView;
    HomeSegMentItems * _leftItem;
    HomeSegMentItems * _rightItem;
}
@property(nonatomic,assign)NSInteger seletedIndexPath;
- (void)setFinds:(NSString *)finds fav:(NSString *)fav;
@end
