//
//  PersonalViewController.h
//  XQSearchPlaces
//
//  Created by xuwenjuan on 13-6-26.
//  Copyright (c) 2013年 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCImagePickerController.h"
@class PersonalViewController;

@protocol PersonalViewDelegate <NSObject>
@optional

- (void)PersonalViewControllerDidCancel:(PersonalViewController*)personal;
@end

@interface PersonalViewController : UIViewController<DLCImagePickerDelegate,UITextFieldDelegate>
{
    UIImageView*bottomBar;
    UITextField*nameFild;
    UITextField*addFild;
    


}
@property(nonatomic,strong)NSString*latitude;
@property(nonatomic,strong)NSString*longtitude;
@property(nonatomic,strong)NSString*placeName;
@property(nonatomic,strong)NSMutableArray*arr;
@property(nonatomic,strong)UIImageView*imageView;
@property(nonatomic,strong)UIButton*addBtn;
@property(nonatomic,strong)NSString*nameStr;
@property(nonatomic,strong)NSString*commentStr;
@property(nonatomic,strong)NSString*timeStr;
@property(nonatomic,strong)NSString*avgCostStr;
@property(nonatomic,strong)NSString*boolISWifi;
@property(nonatomic,strong)NSMutableArray*photoArr;
@property(nonatomic,strong)UIImage*photoImage;




//@property(nonatomic,strong)NSString*singleCityId;
//@property(nonatomic,strong)NSString*singleCityName;
//@property(nonatomic,strong)NSString*cateryStr;
- (id)initWithLatitude:(NSString *)latitudeV longitude:(NSString*)longitudeV placeName:(NSString*)placeNameV image:(UIImage*)imageV singleCityId:(NSString*)singleCityId singleCityName:(NSString*)singleCityName cateryStr:(NSString*)cateryStr;
@end
