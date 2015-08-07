//
//  YelpAPI.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/10/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpObj.h"

@interface YelpAPI : NSObject

// Only used for asynchronous activities
@property (copy, nonatomic) NSMutableArray *placesArray;
@property (copy, nonatomic) NSDictionary *placesDictionary;

/*
 Query the Yelp API synchronously with a given term and location.
 Returns the total number of search results and fills in an array of places
 
 @param term:           The term of the search, e.g: dinner
 @param location:       The location in which the term should be searched for, e.g: San Francisco, CA
 @param placesArray:    An empty array that will be assigned an array of places depending on a category
 */
- (NSNumber *)queryForTotalResults:(NSString *)term
                          location:(NSString *)location
                       placesArray:(NSArray **)placesArrayForTerm;

////////////////////// THIS IS CURRENTLY IRRELEVANT BUT DO NOT DELETE //////////////////////

/*
 Query the Yelp API synchronously  with a given term and location and displays the progress in the log
 Returns an array of activities of the specified searchLimit amount, or the max. number of results found
 
 @param term:           The term of the search, e.g: dinner
 @param location:       The location in which the term should be searched for, e.g: San Francisco, CA
 @param searchLimit:    The amount of ideal outputs
 */
- (NSArray *)queryBusinessesForTerm:(NSString *)term
                           location:(NSString *)location
                        searchLimit:(NSString *)searchLimit;

/*
 Query the Yelp API asynchronously  with a given term and location and displays the progress in the log
 Returns an array of activities of the specified searchLimit amount, or the max. number of results found
 
 @param term:           The term of the search, e.g: dinner
 @param location:       The location in which the term should be searched for, e.g: San Francisco, CA
 @param searchLimit:    The amount of ideal outputs
 */
- (void)queryBusinessesForTerm:(NSString *)term
                      location:(NSString *)location
                   searchLimit:(NSString *)searchLimit
             completionHandler:(void (^)(NSArray *places, NSError *error))completionHandler;

@end
