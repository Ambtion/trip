//
//  UploadInfoViewController.h
//  AhaTrip
//
//  Created by sohu on 13-8-12.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UploadInfoViewControllerDelegate <NSObject>
- (void)uploadInfoViewControllerDidClickAddPic:(UIButton *)button;
- (void)uploadInfoViewControllerDidClickAddLocation:(UIButton *)button;
- (void)uploadInfoViewControllerDidClickSender:(NSDictionary *)info;
@end

@interface UploadInfoViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    
    NSMutableArray* _imagesArray;
    NSString * _locationName;
    UIScrollView * _myScrollView;
    CGFloat _offsetY;
    
    UITextView * _desTextView;
    UIView * _locationView;
    UIView * _optionalView;
    UIView * _bindView;
    NSArray * _bindArray;
    UITextField * _placeHolder;
}
@property(nonatomic,assign)id<UploadInfoViewControllerDelegate> delegate;
- (id)initWithImageUrls:(NSMutableArray *)AimageArray;
- (void)setLocationText:(NSString *)str;
@end
