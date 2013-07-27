//
//  XMLHelper.h
//  LXF_MapGuideDemo
//
//  Created by developer on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLHelper : NSObject<NSXMLParserDelegate>{
    
    NSMutableArray          *dictionaryStackMbAry;
    NSMutableString         *textInProgressMbStr;
    NSError                 *__autoreleasing*errorPointer;
   
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

+ (NSMutableArray*)useNSXMLParserDelegateToGetResult:(NSData *)xmlData;
+ (NSMutableArray*)useGDataXMLNodeToGetResult:(NSData *)xmlData;
@end
