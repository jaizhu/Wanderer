//
//  CityDataParser.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/28/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CHCSVParser.h"

@interface CityDataParser : NSObject <CHCSVParserDelegate>

- (instancetype)initWithCSVWithPathForResource:(NSString *)filePath
                                        ofType:(NSString *)type NS_DESIGNATED_INITIALIZER;

/*
 * Returns the entire parsed array, which holds a separate array in every index representing the elements
 * for all individual lines in the original CSV file.
 * The elements in the sub-array are as follows (according to index):
 * 0) (NSString *) city name, 1) (NSString *) city state, 2) (NSString *) city country, 
 * 3) (NSNumber *) population, 4) (NSNumber *) latitude, 5) (NSNumber *) longitude
 */
- (NSArray *)getParsedArray;

/*
 * Returns dictionary that contains all of the cities and their properties categorized by their state (the key).
 * The sub-arrays from the array returned in getParsedArray (that contain city, state, country, pop, coordinates)
 * are not changed, but are only added in a different order as a member of another array for every state in the dict
 */
- (NSDictionary *)getByStateDictionary;

/*
 * Returns a parsed array, but every index only holds the (NSString) city name for that index
 * in the original CSV parsed array.
 */
- (NSArray *)getParsedCityOnlyArray;

/*
 * Returns a parsed array, but every index only holds the (NSString) state name for that index
 * in the original CSV parsed array.
 */
- (NSArray *)getParsedStateOnlyArray;

/*
 * Returns a parsed array, but every index only holds the (NSString) country name for that index
 * in the original CSV parsed array.
 */
- (NSArray *)getParsedCountryOnlyArray;

@end
