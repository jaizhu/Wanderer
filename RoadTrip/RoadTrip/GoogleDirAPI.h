//
//  GoogleDirAPI.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "TSPSolution.h"
@class CityObj;

@interface GoogleDirAPI : NSObject

/*
 Query the Google Directions Matrix synchronously for driving distance in miles between two cities
 
 @param cityA:  One city or starting point
 @param cityB:  The second city or finishing point
*/
// calculates the driving distance in miles between two cities
- (NSNumber *)drivingDistanceBetweenCityObjects:(CityObj *)cityA
                                     cityB:(CityObj *)cityB;

- (NSNumber *)drivingDistanceBetweenCities:(NSString *)cityA
                                     cityB:(NSString *)cityB;

- (NSString *)encodedPathBetweenCityObjects:(CityObj *)cityA
                                     cityB:(CityObj *)cityB;

- (CLLocationCoordinate2D)coordinatesOfCity:(CityObj *)city;

- (TSPSolution *)shortestPathPossible:(NSArray *)cities;
@end
