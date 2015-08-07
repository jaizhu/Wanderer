//
//  YelpAPI.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/10/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "YelpAPI.h"
#import "NSURLRequest+OAuth.h"
#import "YelpObj.h"
#import "PlaceObj.h"

// MARK: PATH AND SEARCH CONSTANTS
static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"10";

@implementation YelpAPI

// MARK: Querying for the total results for a given category

/* 
 * Returns how many total search results there are 
 */
- (NSNumber *)queryForTotalResults:(NSString *)term
                          location:(NSString *)location
                       placesArray:(NSArray **)placesArrayForTerm {
    __block NSNumber *finalTotalResults = nil;
    __block NSArray *finalPlacesForCategory = nil;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t bgQueue = dispatch_queue_create("API_QUEUE", 0);
    dispatch_async(bgQueue, ^{
        [self queryForTotalResults:term location:location completionHandler:^(NSNumber *totalResults, NSArray *places, NSError *error) {
            finalTotalResults = totalResults;
            finalPlacesForCategory = places;
            dispatch_semaphore_signal(sema);
        }];
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    *placesArrayForTerm = finalPlacesForCategory;
    return finalTotalResults;
}

/* 
 * Query asynchronously for how many search results there are per search 
 */
- (void)queryForTotalResults:(NSString *)term
                    location:(NSString *)location
           completionHandler:(void (^)(NSNumber *totalResults, NSArray *places, NSError *error))completionHandler {
    
    NSLog(@"Querying the Search API for how many results match \'%@\' in \'%@'", term, location);
    
    // Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term location:location searchLimit:kSearchLimit];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSNumber *totalResults = [[NSNumber alloc] init];
        NSMutableArray *placesArray = [[NSMutableArray alloc] init];
        
        if (!error && httpResponse.statusCode == 200) {
            
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"JSON return dictionary:%@", searchResponseJSON);
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            totalResults = searchResponseJSON[@"total"];
            
            NSInteger searchLimitInt = [kSearchLimit integerValue];
            
            // IF THERE ARE NOT ENOUGH BUSINESSES TO MATCH THE SEARCH LIMIT
            if ([businessArray count] < searchLimitInt) {
                NSLog(@"Not enough businesses found, querying %lu businesses matching search result", (unsigned long)[businessArray count]);
                for (int i = 0; i < [businessArray count]; ++i) {
                    NSDictionary *thisBusiness = businessArray[i];
                    NSArray *thisLocation = thisBusiness[@"location"];
                    NSString *thisName = thisBusiness[@"name"];
                    NSArray *thisCategories = thisBusiness[@"categories"];
                    NSString *thisImageURL = thisBusiness[@"image_url"];
                    NSString *thisYelpURL = thisBusiness[@"mobile_url"];
                    
                    PlaceObj *thisPlace = [[PlaceObj alloc] init];
                    thisPlace.location = thisLocation;
                    thisPlace.name = thisName;
                    thisPlace.categories = thisCategories;
                    thisPlace.imageURL = thisImageURL;
                    thisPlace.yelpURL = thisYelpURL;
                    
                    [placesArray addObject:thisPlace];
                }
                NSLog(@"CompletionHandler Ran");
                completionHandler(totalResults, placesArray, error);
            }
            // IF THERE ARE MORE BUSINESSES THAN THE SEARCH LIMIT
            else if ([businessArray count] >= searchLimitInt) {
                NSLog(@"%@: %lu businesses found, querying business info for the top %@ results", term, (unsigned long)[businessArray count], kSearchLimit);
                for (int i = 0; i < searchLimitInt; ++i) {
                    NSDictionary *thisBusiness = businessArray[i];
                    NSArray *thisLocation = thisBusiness[@"location"];
                    NSString *thisName = thisBusiness[@"name"];
                    NSArray *thisCategories = thisBusiness[@"categories"];
                    NSString *thisImageURL = thisBusiness[@"image_url"];
                    NSString *thisYelpURL = thisBusiness[@"mobile_url"];
                    
                    PlaceObj *thisPlace = [[PlaceObj alloc] init];
                    thisPlace.location = thisLocation;
                    thisPlace.name = thisName;
                    thisPlace.categories = thisCategories;
                    thisPlace.imageURL = thisImageURL;
                    thisPlace.yelpURL = thisYelpURL;
                    
                    [placesArray addObject:thisPlace];
                }
                NSLog(@"CompletionHandler Ran");
                completionHandler(totalResults, placesArray, error);
            } else {
                completionHandler(nil, nil, error); // No businesses were found
            }
 
            if (searchResponseJSON[@"total"]) {
                totalResults = searchResponseJSON[@"total"];
            } else {
                completionHandler(nil, nil, error);
                NSLog(@"Error: Something went wrong with the Yelp total search, %@", error.description);
            }
            completionHandler(totalResults, placesArray, error);
        } else {
            NSLog(@"DATA ERROR");
            NSLog(@"Error with Data: %@", [NSString stringWithUTF8String:[data bytes]]);
            completionHandler(nil, nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}

////////////////////// THIS IS CURRENTLY IRRELEVANT BUT DO NOT DELETE //////////////////////

// MARK: Querying for actual businesses and their info

/* 
 * Returns an array of place objects with business info 
 */
- (NSArray *)queryBusinessesForTerm:(NSString *)term
                           location:(NSString *)location
                        searchLimit:(NSString *)searchLimit {
    __block NSArray *placesArray = nil;

    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t bgQueue = dispatch_queue_create("API_QUEUE", 0);
    dispatch_async(bgQueue, ^{
        [self queryBusinessesForTerm:term location:location searchLimit:searchLimit completionHandler:^(NSArray *places, NSError *error) {
            placesArray = places;
            dispatch_semaphore_signal(sema);
        }];
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return placesArray;
}

/* 
 * Query asynchronously for information about however many businesses
 */
- (void)queryBusinessesForTerm:(NSString *)term
                      location:(NSString *)location
                   searchLimit:(NSString *)searchLimit
             completionHandler:(void (^)(NSArray *places, NSError *error))completionHandler {
    
    NSLog(@"Querying the Search API with term \'%@\' and location \'%@'", term, location);
    
    // Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term location:location searchLimit:searchLimit];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSMutableArray *placesArray = [[NSMutableArray alloc] init];
        
        if (!error && httpResponse.statusCode == 200) {
            
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"JSON return dictionary:%@", searchResponseJSON);
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            
            NSInteger searchLimitInt = [searchLimit integerValue];
            
            // IF THERE ARE NOT ENOUGH BUSINESSES TO MATCH THE SEARCH LIMIT
            if ([businessArray count] < searchLimitInt) {
                NSLog(@"Not enough businesses found, querying %lu businesses matching search result", (unsigned long)[businessArray count]);
                for (int i = 0; i < [businessArray count]; ++i) {
                    NSDictionary *thisBusiness = businessArray[i];
                    NSArray *thisLocation = thisBusiness[@"location"];
                    NSString *thisName = thisBusiness[@"name"];
                    NSArray *thisCategories = thisBusiness[@"categories"];
                    NSString *thisImageURL = thisBusiness[@"image_url"];
                    NSString *thisYelpURL = thisBusiness[@"mobile_url"];
                    
                    PlaceObj *thisPlace = [[PlaceObj alloc] init];
                    thisPlace.location = thisLocation;
                    thisPlace.name = thisName;
                    thisPlace.categories = thisCategories;
                    thisPlace.imageURL = thisImageURL;
                    thisPlace.yelpURL = thisYelpURL;
                    
                    [placesArray addObject:thisPlace];
                }
                NSLog(@"CompletionHandler Ran");
                completionHandler(placesArray, error);
            }
            // IF THERE ARE MORE BUSINESSES THAN THE SEARCH LIMIT
            else if ([businessArray count] >= searchLimitInt) {
                NSLog(@"%@: %lu businesses found, querying business info for the top %@ results", term, (unsigned long)[businessArray count], searchLimit);
                for (int i = 0; i < searchLimitInt; ++i) {
                    NSDictionary *thisBusiness = businessArray[i];
                    NSArray *thisLocation = thisBusiness[@"location"];
                    NSString *thisName = thisBusiness[@"name"];
                    NSArray *thisCategories = thisBusiness[@"categories"];
                    NSString *thisImageURL = thisBusiness[@"image_url"];
                    NSString *thisYelpURL = thisBusiness[@"mobile_url"];

                    PlaceObj *thisPlace = [[PlaceObj alloc] init];
                    thisPlace.location = thisLocation;
                    thisPlace.name = thisName;
                    thisPlace.categories = thisCategories;
                    thisPlace.imageURL = thisImageURL;
                    thisPlace.yelpURL = thisYelpURL;

                    [placesArray addObject:thisPlace];
                }
                NSLog(@"CompletionHandler Ran");
                completionHandler(placesArray, error);
            } else {
                completionHandler(nil, error); // No businesses were found
            }
        } else {
            NSLog(@"DATA ERROR");
            NSLog(@"Error with Data: %@", [NSString stringWithUTF8String:[data bytes]]);
            completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}

// MARK: API Request Builders

/*
 * Builds a request to hit the search endpoint with the given parameters.
 
 * @param term        The term of the search, e.g: dinner
 * @param location    The location request, e.g: San Francisco, CA
 * @return             The NSURLRequest needed to perform the search
 */
- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term
                                location:(NSString *)location
                             searchLimit:(NSString *)searchLimit {
    NSDictionary *params = @{
                             @"term": term,
                             @"location": location,
                             @"limit": searchLimit,
                             };
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

/*
 * Builds a request to hit the business endpoint with the given business ID.
 
 * @param     businessID The id of the business for which we request informations
 * @return    The NSURLRequest needed to query the business info
 */
- (NSURLRequest *)_businessInfoRequestForID:(NSString *)businessID {
    NSString *businessPath = [NSString stringWithFormat:@"%@%@", kBusinessPath, businessID];
    return [NSURLRequest requestWithHost:kAPIHost path:businessPath];
}

@end
