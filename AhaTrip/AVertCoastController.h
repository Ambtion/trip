//
//  AVertCoastController.h
//  AhaTrip
//
//  Created by sohu on 13-8-16.
//  Copyright (c) 2013年 ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AvertCoastControllerDelegate <NSObject>
- (void)avertCoastControllerDidSeletedPrice:(NSString *)price uinit:(NSDictionary*)info;
@end
@interface AvertCoastController : UIViewController<ActionSheetCustomPickerDelegate,UIGestureRecognizerDelegate>
- (IBAction)tapGesture:(id)sender;
- (IBAction)screenViewTap:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UITextField *coatNumberFiled;
@property (weak, nonatomic) IBOutlet UITextField *unitFiled;
@property (assign,nonatomic) id<AvertCoastControllerDelegate> delete;
@end
