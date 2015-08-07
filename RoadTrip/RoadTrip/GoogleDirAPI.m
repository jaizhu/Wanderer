//
//  GoogleDirAPI.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "GoogleDirAPI.h"
#import "CityObj.h"

// MARK: PATH AND SEARCH CONSTANTS
static NSString * const kAPIBase = @"https://maps.googleapis.com/maps/api/distancematrix/json?";
static NSString * const kAPIBaseDirections = @"https://maps.googleapis.com/maps/api/directions/json?";
static NSString * const kAPIBaseCoords = @"https://maps.googleapis.com/maps/api/geocode/json?";
static NSString * const kDistanceUnits = @"units=imperial";
static NSString * const kAPIKey = @"AIzaSyAaNdhHu8X95cUU4QQJDD0GKtYzt7zFxEE";

@implementation GoogleDirAPI

// MARK: Distance calculation methods
- (NSNumber *)drivingDistanceBetweenCityObjects:(CityObj *)cityA
                                     cityB:(CityObj *)cityB {
    NSString *cityAStr = cityA.cityName;
    NSString *cityBStr = cityB.cityName;
    
    NSNumber *endingDist = [self queryDrivingDistanceFrom:cityAStr to:cityBStr];
    NSLog(@"Final driving distance in miles: %@", endingDist);
    return endingDist;
}

- (NSNumber *)drivingDistanceBetweenCities:(NSString *)cityA
                                      cityB:(NSString *)cityB {
    NSString *cityAStr = cityA;
    NSString *cityBStr = cityB;
    
    NSNumber *endingDist = [self queryDrivingDistanceFrom:cityAStr to:cityBStr];
    NSLog(@"Final driving distance in miles: %@", endingDist);
    return endingDist;
}

- (NSString *)encodedPathBetweenCityObjects:(CityObj *)cityA
                                     cityB:(CityObj *)cityB {
    NSString *cityAStr = [NSString stringWithFormat:@"%@, %@", cityA.cityName, cityA.cityState];
    NSString *cityBStr = [NSString stringWithFormat:@"%@, %@", cityB.cityName, cityB.cityState];
    
    NSString *encodedPath = [self queryEncodedPathFrom:cityAStr to:cityBStr];
    NSLog(@"Encoded path between %@ and %@ is: %@", cityAStr, cityBStr, encodedPath);
    
    return encodedPath;
}

- (CLLocationCoordinate2D)coordinatesOfCity:(CityObj *)city {
    NSString *addressStr = city.cityName;
    
    CLLocationCoordinate2D encodedPath = [self queryCoordinateOfAddress:addressStr];
    NSLog(@"Coordinates for city are: %f, %f", encodedPath.latitude, encodedPath.longitude);
    
    return encodedPath;
}

- (TSPSolution *)shortestPathPossible:(NSArray *)cities {
    TSPSolution *result = [self queryShortestPathPossible:cities];
    
    return result;
}

// MARK: Synchronous Handling
- (NSNumber *)queryDrivingDistanceFrom:(NSString *)addressA
                                    to:(NSString *)addressB {
    NSLog(@"Querying Google for driving distance between two poitns");
    NSURLRequest *searchRequest = [self _searchRequestWithStartingPoint:addressA
                                                            endingPoint:addressB];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:searchRequest
                                         returningResponse:&response
                                                     error:&error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSString *distString = [[NSString alloc] init];
    
    if (!error && httpResponse.statusCode == 200) {
        NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"Response dictionary:\n%@", searchResponseJSON);
        
        if ([searchResponseJSON valueForKeyPath:@"rows.elements.distance.text"]) {
            NSArray *value = [searchResponseJSON valueForKeyPath:@"rows.elements.distance.text"];
            NSArray *embeddedArray = [value objectAtIndex:0];
            distString = [embeddedArray objectAtIndex:0];
        } else {
            NSLog(@"An ERROR occurred: %@", error.description);
            return @0;
        }
    } else {
        return @0;
    }
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *filter = [distString stringByReplacingOccurrencesOfString:@" mi" withString:@""];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    f.roundingMode = NSNumberFormatterRoundUp;
    f.locale = locale;
    NSNumber *distNum = [f numberFromString:filter];
    
    return distNum;
}

- (NSString *)queryEncodedPathFrom:(NSString *)cityA
                                to:(NSString *)cityB {
    NSLog(@"Querying Google for encoded path between two cities");
    NSURLRequest *searchRequest = [self _directionRequestWithStartingPoint:cityA
                                                               endingPoint:cityB];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:searchRequest
                                         returningResponse:&response
                                                     error:&error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    NSString *directionPathString = [[NSString alloc] init];
    
    if (!error && httpResponse.statusCode == 200) {
        NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"Response dictionary:\n%@", searchResponseJSON);
        
        if ([searchResponseJSON valueForKeyPath:@"routes.overview_polyline.points"]) {
            NSArray *value = [searchResponseJSON valueForKeyPath:@"routes.overview_polyline.points"];
            directionPathString = [value objectAtIndex:0];
        } else {
            NSLog(@"An ERROR occurred: %@", error.description);
            return @"";
        }
    } else {
        return @"";
    }
    
    return directionPathString;
}

- (CLLocationCoordinate2D)queryCoordinateOfAddress:(NSString *)address {
    NSLog(@"Querying Google for coordinate");
    NSURLRequest *searchRequest = [self _coordinateRequestWithPoint:address];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:searchRequest
                                         returningResponse:&response
                                                     error:&error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    CLLocationCoordinate2D coordinates;
    
    if (!error && httpResponse.statusCode == 200) {
        NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"Response dictionary:\n%@", searchResponseJSON);
        
        if ([searchResponseJSON valueForKeyPath:@"results.geometry.location"]) {
            NSArray *latValue = [searchResponseJSON valueForKeyPath:@"results.geometry.location.lat"];
            NSArray *lngValue = [searchResponseJSON valueForKeyPath:@"results.geometry.location.lng"];
            coordinates.latitude = [[latValue objectAtIndex:0] doubleValue];
            coordinates.longitude = [[lngValue objectAtIndex:0] doubleValue];
        } else {
            NSLog(@"An ERROR occurred: %@", error.description);
        }
    }
    
    return coordinates;
}

- (TSPSolution *)queryShortestPathPossible:(NSArray *)cities {
    NSLog(@"Querying Google for TSP route");
    
    NSURLRequest *searchRequest = [self _bestPathRequestWithCities:cities];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:searchRequest
                                         returningResponse:&response
                                                     error:&error];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    TSPSolution *solution = [[TSPSolution alloc] init];
    NSMutableArray *citiesStrings = [[NSMutableArray alloc] init];
    
    if (!error && httpResponse.statusCode == 200) {
        NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSLog(@"Response dictionary:\n%@", searchResponseJSON);
        
        if ([searchResponseJSON valueForKeyPath:@"routes.legs"]) {
            NSArray *legValue = [[NSArray alloc] initWithArray:[searchResponseJSON valueForKeyPath:@"routes.legs"]];
            NSArray *legs = [[NSArray alloc] initWithArray:legValue[0]];
            
            // Find cities in order
            NSString *cityValue = [legs[0] valueForKey:@"start_address"];
            [citiesStrings addObject:cityValue];
            
            for (NSInteger i = 0; i < cities.count - 1; i++) {
                NSDictionary *subDict = legs[i];
                cityValue = [subDict valueForKey:@"end_address"];
                [citiesStrings addObject:cityValue];
            }
            
            // Find map polyline
            NSArray *pathValue = [searchResponseJSON valueForKeyPath:@"routes.overview_polyline.points"];
            
            // Find longest distance (in km)
            NSArray *distancesValues = [searchResponseJSON valueForKeyPath:@"routes.legs.distance.value"];
            NSArray *distances = [distancesValues objectAtIndex:0];
            NSNumber *maxDistance = @([[distances valueForKeyPath:@"@max.intValue"] integerValue] / 1000);
            
            solution.citiesInOrder = citiesStrings;
            solution.encodedPath = [pathValue objectAtIndex:0];
            solution.longestDistance = maxDistance;
            
        } else {
            NSLog(@"An ERROR occurred: %@", error.description);
        }
    }
    
    return solution;
}

// MARK: Constructing NSURLRequest
- (NSURLRequest *)_searchRequestWithStartingPoint:(NSString *)addressA
                                      endingPoint:(NSString *)addressB {
    NSString *origins = [NSString stringWithFormat:@"origins=%@",
                         [addressA stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSString *destinations = [NSString stringWithFormat:@"destinations=%@",
                              [addressB stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    NSString *query =
        [NSString stringWithFormat:@"%@&%@&%@&%@&%@", kAPIBase, origins, destinations, kDistanceUnits, kAPIKey];
    
    NSURL *URL = [[NSURL alloc] initWithString:query];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    NSLog(@"about to query for: %@", query);
    
    return request;
}

- (NSURLRequest *)_directionRequestWithStartingPoint:(NSString *)addressA
                                         endingPoint:(NSString *)addressB {
    NSString *origin = [NSString stringWithFormat:@"origin=%@",
                        [addressA stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    NSString *destination = [NSString stringWithFormat:@"destination=%@",
                             [addressB stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    NSString *query = [NSString stringWithFormat:@"%@&%@&%@&%@", kAPIBaseDirections, origin, destination, kAPIKey];
    
    NSURL *URL = [[NSURL alloc] initWithString:query];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    NSLog(@"about to query for: %@", query);
    
    return request;
}

- (NSURLRequest *)_coordinateRequestWithPoint:(NSString *)address {
    NSString *point = [NSString stringWithFormat:@"address=%@",
                        [address stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    NSString *query = [NSString stringWithFormat:@"%@&%@&%@", kAPIBaseCoords, point, kAPIKey];
    
    NSURL *URL = [[NSURL alloc] initWithString:query];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    NSLog(@"about to query for: %@", query);
    
    return request;
    
}

- (NSURLRequest *)_bestPathRequestWithCities:(NSArray *)citiesToBeConsidered {
    NSMutableArray *cities = [[NSMutableArray alloc] initWithArray:citiesToBeConsidered];
    
    CityObj *startingCity = cities[0];
    [cities removeObject:startingCity];
    
    NSMutableString *citiesString = [[NSMutableString alloc] init];
    for (CityObj *city in cities) {
        [citiesString appendString:[NSString stringWithFormat:@"%@,+USA|",city]];
    }
    
    NSString *origin = [NSString stringWithFormat:@"origin=%@,+USA&destination=%@,+USA&waypoints=optimize:true|",
                        startingCity, startingCity];
    
    NSString *preQuery = [NSString stringWithFormat:@"%@&%@%@&key=%@", kAPIBaseDirections, origin, citiesString, kAPIKey];
    NSString *query = [preQuery stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSURL *URL = [[NSURL alloc] initWithString:[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    NSLog(@"about to query for: %@", query);
    
    return request;
}

@end
