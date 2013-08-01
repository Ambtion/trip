//
//  PersonalImageModel.h
//  XQSearchPlaces
//
//  Created by xuwenjuan on 13-6-26.
//  Copyright (c) 2013年 iObitLXF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalImageModel : NSObject
@property(nonatomic,strong)NSString*longititude;
@property(nonatomic,strong)NSString*latitude;
@property(nonatomic,strong)NSData*imageData;
@property(nonatomic,strong)NSString*placeName;

@end
