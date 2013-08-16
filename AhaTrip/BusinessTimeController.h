//
//  BusinessTimeController.h
//  AhaTrip
//
//  Created by sohu on 13-8-15.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BusinessTimeController;
@protocol BusinessTimeControllerDeleagte <NSObject>
- (void)businessTimeControllerDidSeletedTime:(NSString *)startTime endTime:(NSString *)endTime;
@end

@interface BusinessTimeController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView  *seletedBgView;
@property (weak, nonatomic) IBOutlet UILabel *startCotent;
@property (weak, nonatomic) IBOutlet UILabel *endContent;
- (IBAction)tapGesture:(id)sender;
@property(nonatomic,weak )id<BusinessTimeControllerDeleagte> delegate;
@end
