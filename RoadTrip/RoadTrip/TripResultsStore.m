//
//  TripResultStore.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/9/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "TripResultsStore.h"
#import "Trip.h"
#import "CustomizationOptions.h"
#import "TripGenerator.h"

static int const NumberOfTripsToGenerate = 1;

@interface TripResultsStore ()

@property (nonatomic, copy) NSArray *tripResults;

@end

@implementation TripResultsStore

// MARK: TripResults Store lifecycle
- (instancetype)initWithOptions:(CustomizationOptions *)options {
    self = [super init];
    
    if (self) {
        self.tripResults = [self generateNTrips:options];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithOptions:[CustomizationOptions genericOptions]];
    
}

// MARK: Data source
- (NSArray *)resultsList {
    return [self.tripResults copy];
}

/*
 * Currently returns the first element in allTripResults
 */
- (Trip *)lastTrip {
    return self.tripResults[0];
}

// MARK: Trip generation
- (NSArray *)generateNTrips:(CustomizationOptions *)options {
    TripGenerator *tripGenerator = [[TripGenerator alloc] initWithOptions:options];
    
    NSMutableArray *results = [NSMutableArray array];
    for (int i = 0; i < NumberOfTripsToGenerate; i++) {
        [results addObjectsFromArray:[tripGenerator generateNewTrips]];
    }

    return [results copy];
}

@end
