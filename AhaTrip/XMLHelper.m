//
//  XMLHelper.m
//  LXF_MapGuideDemo
//
//  Created by developer on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLHelper.h"
#import "GDataXMLNode.h"
#import "PlaceDetailVO.h"

NSString *const kXMLHelperTextNodeKey = @"text";
@interface XMLHelper (Internal)

- (id)initWithError:(NSError **)error;
- (NSDictionary *)objectWithData:(NSData *)data;

@end
@implementation XMLHelper
#pragma mark -
#pragma mark use GDataXMLNode

+ (NSMutableArray*)useGDataXMLNodeToGetResult:(NSData*)xmlData{
    
    NSLog(@"Using GDataXMLNode");
    NSString *xmlStr = [[NSString alloc]initWithData:xmlData encoding:NSUTF8StringEncoding];
    NSMutableArray *dataArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *err;
    GDataXMLDocument *document = [[[GDataXMLDocument alloc] initWithXMLString:xmlStr options:0 error:&err] autorelease];
    if (err.code==-1) {
        return nil;
    }
    GDataXMLElement *rootNode = [document rootElement];
    
//      NSArray *array= [rootNode nodesForXPath:@"//PlaceSearchResponse/result" error:nil];
    
    
   NSArray *array = [rootNode elementsForName:@"result"];
    
    
    for (GDataXMLElement *node in array) {
        
        PlaceDetailVO *place = [[PlaceDetailVO alloc]init];
        place.pNameStr =[XMLHelper getElement:node forXPath:@"./name"];
        place.pLatStr = [XMLHelper getElement:node forXPath:@"./geometry/location/lat"];
        place.pLngStr = [XMLHelper getElement:node forXPath:@"./geometry/location/lng"];
        place.pReferenceStr = [XMLHelper getElement:node forXPath:@"./reference"];
        place.pVicinityStr = [XMLHelper getElement:node forXPath:@"./vicinity"];
        [dataArray addObject:place];
        
        [place release];
    }
    [xmlStr release];
    return dataArray;
}

+ (NSString*)getElement:(GDataXMLNode*)aElement forXPath:(NSString*)strXPth {
    NSArray *nodesArray = [aElement nodesForXPath:strXPth error:nil];
    for (GDataXMLNode *node in nodesArray) {
        return [node stringValue];
    }
    return nil;
}

#pragma mark -
#pragma mark use NSXMLParserDelegate
+ (NSMutableArray*)useNSXMLParserDelegateToGetResult:(NSData*)xmlData
{
    NSLog(@"Using NSXMLParserDelegate");
    
    NSMutableArray *resultArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSDictionary *xmlDic = [XMLHelper dictionaryForXMLData:xmlData error:nil];
    
    for (id key in xmlDic) {
        id existingValue = [xmlDic objectForKey:key];
        if ([existingValue isKindOfClass:[NSDictionary class]])
        {
            NSMutableArray *resultAry = [(NSDictionary *)existingValue objectForKey:@"result"];
            for (int i = 0; i<[resultAry count]; i++) {
                PlaceDetailVO *place = [[PlaceDetailVO alloc]init];
                NSDictionary *tempDic = [resultAry objectAtIndex:i];
                
                NSString *latStr = [[[[tempDic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]objectForKey:@"text"];
                NSString *lngStr = [[[[tempDic objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"]objectForKey:@"text"];
               
                place.pLatStr = [XMLHelper getNoLineFeedStr:latStr bHaveNoneSpace:YES];
                place.pLngStr = [XMLHelper getNoLineFeedStr:lngStr bHaveNoneSpace:YES];
                place.pIconURLStr = [XMLHelper getNoLineFeedStr:[[tempDic objectForKey:@"icon"] objectForKey:@"text"] bHaveNoneSpace:YES];
                place.pIDStr = [XMLHelper getNoLineFeedStr:[[tempDic objectForKey:@"id"]objectForKey:@"text"] bHaveNoneSpace:YES];
                place.pNameStr = [XMLHelper getNoLineFeedStr:[[tempDic objectForKey:@"name"]objectForKey:@"text"] bHaveNoneSpace:YES];
                place.pReferenceStr = [XMLHelper getNoLineFeedStr:[[tempDic objectForKey:@"reference"]objectForKey:@"text"] bHaveNoneSpace:YES];
                place.pVicinityStr = [XMLHelper getNoLineFeedStr:[[tempDic objectForKey:@"vicinity"]objectForKey:@"text"] bHaveNoneSpace:YES];
                
                place.pPhotoReferenceStr = [XMLHelper getNoLineFeedStr:[[[tempDic objectForKey:@"photo"]objectForKey:@"photo_reference"]objectForKey:@"text"] bHaveNoneSpace:YES];
                place.pHtmlAttributionStr = [XMLHelper getNoLineFeedStr:[[[tempDic objectForKey:@"photo"]objectForKey:@"html_attribution"]objectForKey:@"text"] bHaveNoneSpace:YES];
                
                [resultArray addObject:place];
                [place release];
                
            }
            
        }
    }
    return resultArray;

}
//返回没有换行和回车的str
+(NSString *)getNoLineFeedStr:(NSString *)aStr bHaveNoneSpace:(BOOL)bNoneSpace
{
    NSString    *str1 = [aStr stringByReplacingOccurrencesOfString: @"\r" withString:@""];
    NSString    *str2 = [str1 stringByReplacingOccurrencesOfString: @"\n" withString:@""];
    if (bNoneSpace) {
        str2 = [str2 stringByReplacingOccurrencesOfString: @" " withString:@""];
    }
    
    return str2;
    
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
{
    XMLHelper *helper = [[XMLHelper alloc] initWithError:error];
    NSDictionary *rootDictionary = [helper objectWithData:data];
    [helper release];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLHelper dictionaryForXMLData:data error:error];
}



#pragma mark -
#pragma mark Parsing

- (id)initWithError:(NSError **)error
{
    if (self = [super init])
    {
        errorPointer = error;
    }
    return self;
}

- (void)dealloc
{
    [dictionaryStackMbAry release];
    [textInProgressMbStr release];
    [super dealloc];
}

- (NSDictionary *)objectWithData:(NSData *)data
{
    // Clear out any old data
    [dictionaryStackMbAry release];
    [textInProgressMbStr release];
    
    dictionaryStackMbAry = [[NSMutableArray alloc] init];
    textInProgressMbStr = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStackMbAry addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // Return the stack’s root dictionary on success
    if (success)
    {
        NSDictionary *resultDict = [dictionaryStackMbAry objectAtIndex:0];
        return resultDict;
    }
    
    return nil;
}
#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStackMbAry lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there’s already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn’t exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [dictionaryStackMbAry addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStackMbAry lastObject];
    
    // Set the text property
    if ([textInProgressMbStr length] > 0)
    {
        // Get rid of leading + trailing whitespace
        [dictInProgress setObject:textInProgressMbStr forKey:kXMLHelperTextNodeKey];
        
        // Reset the text
        [textInProgressMbStr release];
        textInProgressMbStr = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [dictionaryStackMbAry removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgressMbStr appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser’s error object
   *errorPointer = parseError;
}

@end
