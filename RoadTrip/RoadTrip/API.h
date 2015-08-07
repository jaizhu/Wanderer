//
//  API.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/13/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CityObj.h"
#import "YelpAPI.h"
#import "GoogleDirAPI.h"
#import "TSPSolution.h"

@interface API : NSObject

// MARK: City finding and filtering
/*
 * Creates a CityObj that will have the following properties initialized: cityName, cityState, population, location.
 */
- (CityObj *)preliminaryAttributeAssigner:(NSString *)cityName
                                withState:(NSString *)cityState
                          withParsedArray:(NSArray *)parsedArray;

/* 
 * Returns an array with a certain number of CityObj objects, where the closest city is no less than 
 * 90 miles away, and the farthest is within the range provided. The original CityObj is first index in
 * the array, and the following CityObj objects are sorted, with first ones having the larger population.
 * Provided array must have CityObj objects created from the preliminaryAttributeAssigner.
 */
- (NSArray *)findCitiesInRange:(NSUInteger)km
                      nearCity:(CityObj *)city
                    fromCities:(NSArray *)allCities;


// MARK: Directions and distance calculators
/*
 * These two methods calculate the driving distance in TODO:kilometers between two cities
 */
- (NSNumber *)drivingDistanceBetweenCityObjects:(CityObj *)cityA
                                          cityB:(CityObj *)cityB;

- (NSNumber *)drivingDistanceBetweenCities:(NSString *)cityA
                                     cityB:(NSString *)cityB;

/*
 * Returns Google Maps direction path for our map
 */
- (NSString *)encodedDirectionPathBetweenCityObjects:(CityObj *)cityA
                                               cityB:(CityObj *)cityB;

- (TSPSolution *)shortestPathPossible:(NSArray *)cities;

- (CLLocationCoordinate2D)coordinatesForCity:(CityObj *)city;

// MARK: City category attributes and places

/*
 * Find specific number of activities in a city
 */
- (NSArray *)findPlacesInCity:(CityObj *)city
                     category:(NSString *)category
                  searchLimit:(NSString *)searchLimit;

/*
 * Returns array of CityObj with categorized attributes included
 */
- (NSArray *)assignCityAttributes:(NSArray *)filteredCityArr;

/* 
 * Adds city relevance in categories attributes to the CityObj object.
 */
- (CityObj *)cityAttributeAssigner:(CityObj *)city;

/*
 * Finds 0-1 relevance of a city in a certain category
 */
- (NSNumber *)cityRelevanceInCategory:(CityObj *)city
                             category:(NSString *)key
                          denominator:(CGFloat)denominator;

/*
 * Compares CityObj objects based on a specific category, returns the more relevant one
 */
- (CityObj *)compareCityRelevanceInCategory:(CityObj *)cityA
                                      cityB:(CityObj *)cityB
                                   category:(NSString *)key;






@end
