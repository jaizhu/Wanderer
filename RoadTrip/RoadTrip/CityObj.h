//
//  CityObj.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CityObj : NSObject <NSCoding>

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityState;
@property (nonatomic, copy) NSNumber *population;
@property (nonatomic) CLLocationCoordinate2D location;

/*
 * Category by population determined by:
 * 5,000,000 + -> 0
 * 3,000,000 - 4,999,999 -> 1
 * 1,800,000 - 2,999,999 -> 2
 * 1,000,000 - 1,799,999 -> 3
 * 700,000 - 999,999 -> 4
 * 500,000 - 699,999 -> 5
 * 350,000 - 499,999 -> 6
 * 200,000 - 349,999 -> 7
 * 100,000 - 199,999 -> 8
 * 60,000 - 99,999 -> 9
 * - 59,999 -> 10
 */
@property (nonatomic, copy) NSNumber *popCategory;

@property (nonatomic, copy) NSNumber *identifier;
@property (nonatomic, copy) NSArray *distancesToOtherCities;
@property (nonatomic) BOOL alreadyVisited;

// Relevance dictionary that contains all constants 0-1 of category relevance
@property (strong, nonatomic) NSMutableDictionary *relevanceDict;

// Places dictionary that contains arrays of places for each category
@property (strong, nonatomic) NSMutableDictionary *placesDict;

/* 
 * Assigns city name and initializes relevance constant keys to default 999
 * All attribute fields are undefined after initializing
*/
- (instancetype)initWithName:(NSString *)name andState:(NSString *)state NS_DESIGNATED_INITIALIZER;

@end
