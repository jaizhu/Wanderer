//
//  API.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/13/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

#import "API.h"
#import "CityObj.h"
#import "YelpAPI.h"
#import "PlaceObj.h"
#import "GoogleDirAPI.h"

@interface API ()

@property (nonatomic, strong) NSDictionary *relevanceBenchmarks;

@end

@implementation API

// MARK: Controller lifecycle
- (instancetype)init {
    self = [super init];
    
    if (self) {
        /*
         * Array indexes represent population group:
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
        // These numbers are hard-coded since they have to be calibrated
        NSArray *parksBenchmarks = @[@2500, @1700, @750, @350, @180, @145, @120, @95, @75, @55, @40];
        NSArray *perfArtsBenchmarks = @[@1600, @1150, @600, @280, @180, @135, @80, @60, @45, @35, @25];
        NSArray *museumsBenchamrks = @[@350, @250, @150, @75, @60, @50, @40, @30, @25, @20, @20];
        NSArray *restaurantsBenchmarks = @[@6000, @3500, @2400, @1400, @1000, @850, @700, @600, @450, @300, @200];
        NSArray *nightlifeBenchmarks = @[@2000, @1700, @1300, @1000, @700, @550, @400, @300, @200, @200, @150];
        NSArray *allBenchmarks =
            @[parksBenchmarks, perfArtsBenchmarks, museumsBenchamrks, restaurantsBenchmarks, nightlifeBenchmarks];
        NSArray *allCategories = @[@"Parks", @"Performing Arts", @"Museums", @"Best Restaurants", @"Nightlife"];
        self.relevanceBenchmarks = [[NSMutableDictionary alloc] initWithObjects:allBenchmarks forKeys:allCategories];
    }
    
    return self;
}

// MARK: City finding and filtering
- (CityObj *)preliminaryAttributeAssigner:(NSString *)cityName
                                withState:(NSString *)cityState
                          withParsedArray:(NSArray *)parsedArray {
    CityObj *resultingCity = [[CityObj alloc] initWithName:cityName andState:cityState];
    
    for (NSInteger i = 0; i < parsedArray.count; i++) {
        NSString *internalCityName = [[parsedArray objectAtIndex:i] objectAtIndex:0];
        NSString *internalCityState = [[parsedArray objectAtIndex:i] objectAtIndex:1];
        CLLocationCoordinate2D coordinate;
        
        if ([internalCityName isEqualToString:cityName] && [internalCityState isEqualToString:cityState]) {
            resultingCity.population = [[parsedArray objectAtIndex:i] objectAtIndex:3];
            coordinate.latitude = [[[parsedArray objectAtIndex:i] objectAtIndex:4] doubleValue];
            coordinate.longitude = [[[parsedArray objectAtIndex:i] objectAtIndex:5] doubleValue];
            resultingCity.location = coordinate;
        }
    }
    
    return resultingCity;
}

- (NSArray *)findCitiesInRange:(NSUInteger)km
                      nearCity:(CityObj *)city
                    fromCities:(NSArray *)allCities {
    NSMutableArray *cityArray = [[NSMutableArray alloc] initWithObjects:city, nil];
    
    for (CityObj *currentCity in allCities) {
        NSInteger distance = (NSInteger)[self straightLineDistanceBetweenCity:city andCity:currentCity];
        
        if (distance < km && distance > 150) {
            [cityArray addObject:currentCity];
        }
    }
    
    return cityArray;
}

- (CGFloat)straightLineDistanceBetweenCity:(CityObj *)cityA andCity:(CityObj *)cityB {
    CLLocationCoordinate2D cityACoord = cityA.location;
    CLLocationCoordinate2D cityBCoord = cityB.location;
    CGFloat result = [self distanceBetweenLat1:cityACoord.latitude
                                          lon1:cityACoord.longitude
                                          lat2:cityBCoord.latitude
                                          lon2:cityBCoord.longitude];
    
    return result;
}

/*
 * Obtained from rosettacode.org
 */
- (double)distanceBetweenLat1:(double)lat1 lon1:(double)lon1
                         lat2:(double)lat2 lon2:(double)lon2 {
    // Degrees to radians
    double lat1rad = lat1 * M_PI/180;
    double lon1rad = lon1 * M_PI/180;
    double lat2rad = lat2 * M_PI/180;
    double lon2rad = lon2 * M_PI/180;
    
    // Deltas
    double dLat = lat2rad - lat1rad;
    double dLon = lon2rad - lon1rad;
    
    double a = sin(dLat/2) * sin(dLat/2) + sin(dLon/2) * sin(dLon/2) * cos(lat1rad) * cos(lat2rad);
    double c = 2 * asin(sqrt(a));
    double R = 6372.8;
    return R * c;
}

// MARK: Directions and distance calculators
- (NSNumber *)drivingDistanceBetweenCityObjects:(CityObj *)cityA
                                          cityB:(CityObj *)cityB {
    CGFloat distance = [self straightLineDistanceBetweenCity:cityA andCity:cityB];
    return [NSNumber numberWithFloat:distance];
    
//    GoogleDirAPI *googleDirAPIObj = [[GoogleDirAPI alloc] init];
//    return [googleDirAPIObj drivingDistanceBetweenCityObjects:cityA cityB:cityB];
}

- (NSNumber *)drivingDistanceBetweenCities:(NSString *)cityA
                                     cityB:(NSString *)cityB {
    GoogleDirAPI *googleDirAPIObj = [[GoogleDirAPI alloc] init];
    return [googleDirAPIObj drivingDistanceBetweenCities:cityA cityB:cityB];
}

- (NSString *)encodedDirectionPathBetweenCityObjects:(CityObj *)cityA
                                               cityB:(CityObj *)cityB {
    GoogleDirAPI *googleDirAPIObj = [[GoogleDirAPI alloc] init];
    return [googleDirAPIObj encodedPathBetweenCityObjects:cityA cityB:cityB];
}

- (TSPSolution *)shortestPathPossible:(NSArray *)cities {
    GoogleDirAPI *googleDirAPIobj = [[GoogleDirAPI alloc] init];
    return [googleDirAPIobj shortestPathPossible:cities];
}

- (CLLocationCoordinate2D)coordinatesForCity:(CityObj *)city {
    return city.location;
}

// MARK: City category attributes and places
/* 
 * Finds a specified number of activities in a city 
 */
- (NSArray *)findPlacesInCity:(CityObj *)city
                     category:(NSString *)category
                  searchLimit:(NSString *)searchLimit {
    NSString *cityName = city.cityName;
    NSString *stateName = city.cityState;
    NSString *location = [NSString stringWithFormat:@"%@,+%@", cityName, stateName];
    YelpAPI *yelpAPIobj = [[YelpAPI alloc] init];
    
    NSArray *placesArray = [yelpAPIobj queryBusinessesForTerm:category location:location searchLimit:searchLimit];
    
    return placesArray;
}

/* 
 * Returns an array of fully complete city objects, given an array of city names (strings)
 */
- (NSArray *)assignCityAttributes:(NSArray *)filteredCityArr {
    
    CityObj *cityOut = [[CityObj alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (CityObj *city in filteredCityArr) {
        cityOut = [self cityAttributeAssigner:city];
        [returnArray addObject:cityOut];
    }
    
    return returnArray;
}

/* 
 * Turns a raw city string into a city object with all attributes per category
 * THIS INCLUDES: all attribute constants and arrays of places per category (number based on search limit in YelpAPI.m)
 */
- (CityObj *)cityAttributeAssigner:(CityObj *)city {
    NSNumber *relevanceConst = [[NSNumber alloc] init];
    NSMutableArray *allKeys = [[city.relevanceDict allKeys] mutableCopy];
    
    // Set population category
    NSInteger population = [city.population integerValue];
    if (population >= 5000000) {
        city.popCategory = @0;
    } else if (population >= 3000000 && population < 5000000) {
        city.popCategory = @1;
    } else if (population >= 1800000 && population < 3000000) {
        city.popCategory = @2;
    } else if (population >= 1000000 && population < 1800000) {
        city.popCategory = @3;
    } else if (population >= 700000 && population < 1000000) {
        city.popCategory = @4;
    } else if (population >= 500000 && population < 700000) {
        city.popCategory = @5;
    } else if (population >= 350000 && population < 500000) {
        city.popCategory = @6;
    } else if (population >= 200000 && population < 350000) {
        city.popCategory = @7;
    } else if (population >= 100000 && population < 200000) {
        city.popCategory = @8;
    } else if (population >= 60000 && population < 100000) {
        city.popCategory = @9;
    } else if (population < 60000) {
        city.popCategory = @10;
    }
    
    for (NSString *key in allKeys) {
        CGFloat denominator =
            [[[self.relevanceBenchmarks objectForKey:key] objectAtIndex:[city.popCategory integerValue]] floatValue];
        
        relevanceConst = [self cityRelevanceInCategory:city category:key denominator:denominator];
        
        [city.relevanceDict setValue:relevanceConst forKey:key];
    }
    return city;
}

/* 
 * Finds the number 0-1 of relevance of one city in a category
 * EDIT: Also sets the city's arrays of places so we don't have to query again separately
 */
- (NSNumber *)cityRelevanceInCategory:(CityObj *)city
                             category:(NSString *)key
                          denominator:(CGFloat)denominator {
    NSString *cityName = city.cityName;
    NSArray *arrayForKey = [[NSArray alloc] init];
    
    YelpAPI *yelpAPI = [[YelpAPI alloc] init];
    NSNumber *totalResultsNSNumber = [yelpAPI queryForTotalResults:key location:cityName placesArray:&arrayForKey];
    
    CGFloat totalResultsFloat = [totalResultsNSNumber floatValue];
    CGFloat relevanceConstFloat = totalResultsFloat / denominator;
    if (relevanceConstFloat > 1.0) {
        relevanceConstFloat = 1.0;
    }
    NSNumber *relevanceConst = @(relevanceConstFloat);
    
    // Setting the array for the city object
    [city.placesDict setObject:arrayForKey forKey:key];
    
    return relevanceConst;
}

/* 
 * Compares two cities based upon a certain category 
 */
- (CityObj *)compareCityRelevanceInCategory:(CityObj *)cityA
                                      cityB:(CityObj *)cityB
                                   category:(NSString *)key {
    if ([cityA.relevanceDict objectForKey:key] >= [cityB.relevanceDict objectForKey:key]) {
        return cityA;
    } else {
        return cityB;
    }
}

@end
