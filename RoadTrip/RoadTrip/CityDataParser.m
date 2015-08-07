//
//  CityDataParser.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/28/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "CityDataParser.h"

@interface CityDataParser ()

@property (nonatomic, strong) NSMutableArray *parsedFile;
@property (nonatomic, strong) NSMutableArray *currentLine;

// Dictionary with parsed file with states as keys
@property (nonatomic, strong) NSMutableDictionary *keyedCityList;

@end

@implementation CityDataParser

// MARK: Controller lifecycle
- (instancetype)initWithCSVWithPathForResource:(NSString *)filePath ofType:(NSString *)type {
    self = [super init];
    
    if (self) {
        self.keyedCityList = [[NSMutableDictionary alloc] init];
        
        NSString *pathName = [[NSBundle mainBundle] pathForResource:filePath ofType:type];
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSString *content;
        
        if ([fm fileExistsAtPath:pathName]) {
            content = [NSString stringWithContentsOfFile:pathName
                                              encoding:NSASCIIStringEncoding
                                                 error:nil];
        }
        [self parseStringWithContent:content];
    }
    
    return self;
}

- (void)parseStringWithContent:(NSString *)content {
    CHCSVParser *parser = [[CHCSVParser alloc] initWithCSVString:content];
    
    parser.recognizesBackslashesAsEscapes = YES;
    [parser setDelegate:self];
    
    [parser parse];
    
    [self setUpDictionary];
}

/*
 * Creates dictionary that contains all of the cities and their properties categorized by their state (the key).
 * The sub-arrays from the original parsedFile NSMutableArray (that contain city, state, country, pop, coordinates)
 * are not changed, but are only added in a different order as a member of another array for every state in the dict
 */
- (void)setUpDictionary {
    NSMutableArray *statesSoFar = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.parsedFile.count; i++) {
        NSMutableArray *currentDictValue = [[NSMutableArray alloc] init];
        NSString *currentState = [self.parsedFile[i] objectAtIndex:1];
        
        // Checking if state already contains key for the state or not
        if ([statesSoFar containsObject:currentState]) {
            // Add another object to dict value array
            [[self.keyedCityList objectForKey:currentState] addObject:self.parsedFile[i]];
        } else {
            // Add first object to dict value array, and add that array to the dict
            [currentDictValue addObject:self.parsedFile[i]];
            [self.keyedCityList setObject:currentDictValue forKey:currentState];
            [statesSoFar addObject:currentState];
        }
    }
}

// MARK: Parsing result access
- (NSArray *)getParsedArray {
    return self.parsedFile;
}

- (NSDictionary *)getByStateDictionary {
    return self.keyedCityList;
}

- (NSArray *)getParsedCityOnlyArray {
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.parsedFile.count; i++) {
        [filteredArray addObject:[self.parsedFile[i] objectAtIndex:0]];
    }
    
    return filteredArray;
}

- (NSArray *)getParsedStateOnlyArray {
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.parsedFile.count; i++) {
        [filteredArray addObject:[self.parsedFile[i] objectAtIndex:1]];
    }
    
    return filteredArray;
}

- (NSArray *)getParsedCountryOnlyArray {
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.parsedFile.count; i++) {
        [filteredArray addObject:[self.parsedFile[i] objectAtIndex:2]];
    }
    
    return filteredArray;
}

// MARK: Parser delegate methods
- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    self.parsedFile = [[NSMutableArray alloc] init];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    self.currentLine = [[NSMutableArray alloc] init];
}

/*
 * Parses a field. Removes leading spaces from the state and country fields.
 * Also converts the population, latitude and longitude fields from NSString objects to NSNumber objects
 */
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    
    switch (fieldIndex) {
        case 0:
            [self.currentLine addObject:field];
            break;
        case 1:
        case 2:
            // Needed because of leading space in CSV file in the state and country fields
            field = [field stringByReplacingOccurrencesOfString:@" " withString:@""];
            [self.currentLine addObject:field];
            break;
        case 3:
        case 4:
        case 5:
        {
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            f.locale = locale;
            NSNumber *number = [f numberFromString:field];
            [self.currentLine addObject:number];
        }
            break;
        default:
            break;
    }
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [self.parsedFile addObject:self.currentLine];
    self.currentLine = nil;
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", error);
    self.parsedFile = nil;
}

@end
