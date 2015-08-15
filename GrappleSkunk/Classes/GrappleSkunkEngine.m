//
//  GrappleSkunkEngine.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "GrappleSkunkEngine.h"
#import "GraphMachine.h"

static NSString * const kDemoJSONDataStockdataKey = @"stockdata";
static NSString * const kDemoJSONDataDateKey = @"date";
static NSString * const kDemoJSONDataCloseKey = @"close";

@interface GrappleSkunkEngine ()

@property (strong, nonatomic) GraphMachine* theGraphMachine;
@property (strong, nonatomic) NSDateFormatter * theDateFormatter;

@end

@implementation GrappleSkunkEngine

- (instancetype)init
{
    self = [super init];
    if (self) {
        _theGraphMachine = [GraphMachine new];
        _theDateFormatter = [NSDateFormatter new];
        
        [_theDateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return self;
}

- (void)addDataFromProjectFile:(NSString*)projectFile
{
    NSString* projectFilePath = [[NSBundle mainBundle] pathForResource:projectFile ofType:@"json"];
    NSString* jsonString = [[NSString alloc] initWithContentsOfFile:projectFilePath encoding:NSUTF8StringEncoding error:NULL];
    
    [self addDataFromJSONString:jsonString];
}

- (void)addDataFromJSONString:(NSString*)jsonString
{
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error =  nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    [self addDataFromDemoDictionary: jsonDictionary];
}

- (void)addDataFromDemoDictionary:(NSDictionary*)dataDictionary
{
    NSArray *demoDataArray = dataDictionary[kDemoJSONDataStockdataKey];
    
    if( demoDataArray != nil )
    {
        for( id item in demoDataArray )
        {
            NSDictionary* itemDictionary = (NSDictionary*)item;
            NSString* itemDateString = itemDictionary[kDemoJSONDataDateKey];
            NSString* itemCloseString = itemDictionary[kDemoJSONDataCloseKey];
            
            CGFloat itemCloseValue = [itemCloseString floatValue];
            NSDate *itemCloseDate=[self.theDateFormatter dateFromString:itemDateString];
            NSLog(@"%@",itemCloseDate);
            
            [self.theGraphMachine addDataPointWithXValue:[itemCloseDate timeIntervalSinceReferenceDate] yValue:itemCloseValue label:itemDateString auxView:nil];
        }
    }
}

@end
