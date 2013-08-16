//
//  HasWiFiController.h
//  AhaTrip
//
//  Created by sohu on 13-8-16.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HasWiFiControllerDelegate <NSObject>
- (void)wifiControllerDidSeletedWithIndexTag:(NSInteger)tag;
@end
@interface HasWiFiController : UIViewController

@property (weak, nonatomic) id<HasWiFiControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *seletedBgView;
- (IBAction)tapGesture:(id)sender;
@end
