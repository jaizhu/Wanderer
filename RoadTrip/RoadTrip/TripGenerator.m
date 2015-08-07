//
//  TripGenerator.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "TripGenerator.h"
#import "Trip.h"
#import "CustomizationOptions.h"
#import "API.h"
#import "CityDataParser.h"
#import "TSPSolution.h"

static NSInteger const kKilometersTraveledPerHour = 100;
static NSInteger const kMaxTravelHrsPerDay = 10;
static NSInteger const kMaxCitiesVisited = 9;
static CGFloat const kWeightDown = 0.85;
static CGFloat const kWeightUp = 1.6;

@interface TripGenerator ()

@property (nonatomic, strong) API *apiObj;
@property (nonatomic, strong) CityDataParser *dataParser;

@property (nonatomic, strong) NSString *startingCity;
@property (nonatomic, strong) NSString *startingState;
@property (nonatomic, strong) NSNumber *tripDuration;
@property (nonatomic, strong) NSNumber *distanceRadiusAroundStartingCity;
@property (nonatomic, strong) NSNumber *farthestDistanceToTravel;

@property (nonatomic) NSInteger cityCountToBeConsidered;
@property (nonatomic) NSInteger cityCountToBeVisited;
@property (nonatomic) NSString *tripCategoryA;
@property (nonatomic) NSString *tripCategoryB;

@end

@implementation TripGenerator

// TODO: Notes: keep a max single travel distance of farthestDistanceToTravel. It reduces likelihood of awkward situations of going exactly the other way
// TODO: Convert Google to km
// TODO: Weight positively being farther than a certain distance from the last city

// MARK: Generator lifecycle and setup
- (instancetype)initWithOptions:(CustomizationOptions *)options {
    self = [super init];
    
    if (self) {
        self.apiObj = [[API alloc] init];
        self.dataParser = [[CityDataParser alloc] initWithCSVWithPathForResource:@"CitiesPopulationsLocations"
                                                                          ofType:@"csv"];
        
        self.startingCity = options.startingCity[0];
        self.startingState = options.startingCity[1];
        self.tripDuration = @([options.tripDuration integerValue]);
        self.distanceRadiusAroundStartingCity = [self convertDistanceInHoursToTime:options.farthestDistanceInHours];
        self.farthestDistanceToTravel = self.distanceRadiusAroundStartingCity;
        
        NSInteger tempDuration = [self.tripDuration integerValue];
        if (tempDuration < 9) {
            self.cityCountToBeVisited = 3;
            if (tempDuration < 5) {
                self.farthestDistanceToTravel = @300;
                self.distanceRadiusAroundStartingCity = @300;
            }
            self.cityCountToBeConsidered = self.cityCountToBeVisited * 4;
        } else if (tempDuration > 27) {
            self.cityCountToBeVisited = kMaxCitiesVisited;
            self.cityCountToBeConsidered = self.cityCountToBeVisited * 2;
        } else if (tempDuration < 18){
            self.cityCountToBeVisited = tempDuration / 2.5;
            self.cityCountToBeConsidered = self.cityCountToBeVisited * 3;
        } else {
            self.cityCountToBeVisited = tempDuration / 3;
            self.cityCountToBeConsidered = self.cityCountToBeVisited * 2;
        }
    }
    
    return self;
}

/*
 * Converts time to distance and checks to make sure user input about travel time is reasonable.
 */
- (NSNumber *)convertDistanceInHoursToTime:(NSNumber *)distanceInHours {
    if ([distanceInHours intValue] > kMaxTravelHrsPerDay) {
        return @(kKilometersTraveledPerHour * kMaxTravelHrsPerDay);
    } else {
        return @(kKilometersTraveledPerHour * [distanceInHours intValue]);
    }
}

// MARK: Trip Generation
- (NSArray *)generateNewTrips {
    
    NSMutableArray *citiesToVisit = [NSMutableArray arrayWithArray:[self cityArraySetup]];
    
    // First city is starting city
    CityObj *currentCity = citiesToVisit[0];
    currentCity.alreadyVisited = YES;
    [citiesToVisit removeObject:citiesToVisit[0]];
    NSMutableArray *citiesWillVisit = [NSMutableArray arrayWithObject:currentCity];
    
    // Randomly come up with categories that will be considered
    NSArray *placeKeys = [[NSArray alloc] initWithArray:currentCity.placesDict.allKeys];
    
    NSMutableArray *categoriesASelected = [[NSMutableArray alloc] init];
    NSMutableArray *categoriesBSelected = [[NSMutableArray alloc] init];
    BOOL isIndexTaken = NO;
    while (categoriesASelected.count < 5) {
        unsigned int aIndex = arc4random_uniform((unsigned int)[placeKeys count]);
        unsigned int bIndex = arc4random_uniform((unsigned int)[placeKeys count]);
        NSString *currentA = placeKeys[aIndex];
        NSString *currentB = placeKeys[bIndex];
        
        for (NSInteger i = 0; i < categoriesASelected.count; i++) {
            if (([categoriesASelected[i] isEqualToString:currentA] &&
                    [categoriesBSelected[i] isEqualToString:currentB]) ||
                ([categoriesASelected[i] isEqualToString:currentB] &&
                    [categoriesBSelected[i] isEqualToString:currentA])) {
                    isIndexTaken = YES;
            }
        }
        
        if (![currentA isEqualToString:currentB] && !isIndexTaken) {
            [categoriesASelected addObject:currentA];
            [categoriesBSelected addObject:currentB];
        }
        
        isIndexTaken = NO;
    }
    
    // Create every single trip
    NSMutableArray *trips = [[NSMutableArray alloc] init];
    
    NSInteger numTrips;
    if (self.cityCountToBeVisited < 5) {
        numTrips = 3;
    } else {
        numTrips = 5;
    }
    
    for (NSInteger i = 0; i < numTrips; i++) {
        NSString *categoryA = categoriesASelected[i];
        NSString *categoryB = categoriesBSelected[i];
        
        NSArray *citiesToBeTrimmed = [[NSArray alloc] initWithArray:citiesToVisit];
        NSMutableArray *citiesYetToVisit =
            [[NSMutableArray alloc] initWithArray:[self randomCityArrayTrimmer:citiesToBeTrimmed removeCount:4]];
        NSMutableArray *citiesThatWillVisit = [[NSMutableArray alloc] initWithArray:citiesWillVisit];
    
        // Define cities to visit (other than last one)
        // Difference is these ignore distance to starting city
        CityObj *bestNextCity;
        for (NSInteger j = 1; j < self.cityCountToBeVisited -1; j++) {
            bestNextCity = [self findNextCity:citiesYetToVisit categoryA:categoryA categoryB:categoryB];
            
            [citiesYetToVisit removeObject:bestNextCity];
            [citiesThatWillVisit addObject:bestNextCity];
        }
        
        // Define last city to be visited
        bestNextCity = [self findLastCity:citiesYetToVisit
                            currentCityID:[bestNextCity.identifier integerValue]
                                categoryA:categoryA
                                categoryB:categoryB];
        [citiesYetToVisit removeObject:bestNextCity];
        [citiesThatWillVisit addObject:bestNextCity];
        
        // Find correct path to follow
        TSPSolution *shortestPath = [self.apiObj shortestPathPossible:citiesThatWillVisit];
        NSMutableArray *citiesToVisitInOrder = [[NSMutableArray alloc] init];
        for (NSString *currentCityString in shortestPath.citiesInOrder) {
            NSArray *cityComponents = [currentCityString componentsSeparatedByString:@","];
            for (CityObj *cityInConsideration in citiesThatWillVisit) {
                if ([cityInConsideration.cityName isEqualToString:cityComponents[0]]) {
                    [citiesToVisitInOrder addObject:cityInConsideration];
                }
            }
        }
        
        // Create trip
        TripOptions *newTripOptions = [[TripOptions alloc] init];
        newTripOptions.startingLocation = [citiesToVisitInOrder[0] description];
        newTripOptions.tripDuration = self.tripDuration;
        newTripOptions.farthestPointDistance = shortestPath.longestDistance;
        newTripOptions.citiesVisited = citiesToVisitInOrder;
        newTripOptions.mapPath = shortestPath.encodedPath;
        newTripOptions.tripCategoryA = categoryA;
        newTripOptions.tripCategoryB = categoryB;
        
        Trip *generatedTrip = [[Trip alloc] initWithOptions:newTripOptions];
    
        [trips addObject:generatedTrip];
    }
        
    return trips;
}

/*
 * Randomly removes n cities
 */
- (NSArray *)randomCityArrayTrimmer:(NSArray *)cities removeCount:(NSInteger)count {
    NSMutableArray *trimmingCities = [[NSMutableArray alloc] initWithArray:cities];
    
    while (count > 0 && trimmingCities.count > self.cityCountToBeVisited) {
        NSInteger randomIndex = arc4random_uniform((unsigned int)trimmingCities.count);
        [trimmingCities removeObjectAtIndex:randomIndex];
        count--;
    }
    
    return trimmingCities;
}

/*
 * Returns the CityObj that should be next. This method will be used for every city but
 * the last one.
 */
- (CityObj *)findNextCity:(NSArray *)citiesYetToVisit categoryA:(NSString *)catA categoryB:(NSString *)catB {
    CityObj *nextCity;
    NSInteger chanceSum;
    NSInteger previousCitySum = -1;
    for (CityObj *city in citiesYetToVisit) {
        chanceSum = 0;
        // First run ignores distance to starting city
        for (NSInteger i = 1; i < [city.distancesToOtherCities count]; i++) {
            chanceSum += [[city.distancesToOtherCities objectAtIndex:i] integerValue];
        }
        
        chanceSum += (NSInteger)(1000.0 - (1000.0 * [[city.relevanceDict valueForKey:catA] floatValue]));
        chanceSum += (NSInteger)(1000.0 - (1000.0 * [[city.relevanceDict valueForKey:catB] floatValue]));
        chanceSum += 1000 - arc4random_uniform(1000);
        
        if (chanceSum < previousCitySum || previousCitySum < 0) {
            nextCity = city;
        }
        previousCitySum = chanceSum;
    }
    nextCity.alreadyVisited = YES;
    
    return nextCity;
}

/*
 * Returns the CityObj that should be last (before returning to starting city).
 * This method only considers the current and the starting cities, weighting down the
 * distance of starting city, and up the distance to current distance (with lower 
 * total distance being better).
 */
- (CityObj *)findLastCity:(NSArray *)citiesYetToVisit
            currentCityID:(NSInteger)currentID
                categoryA:(NSString *)catA
                categoryB:(NSString *)catB {
    CityObj *lastCity;
    CGFloat chanceSum;
    NSInteger previousCitySum = -1;
    for (CityObj *city in citiesYetToVisit) {
        chanceSum = 0;
        
        // Only consider distances to current and starting cities
        chanceSum +=
            kWeightUp * [[city.distancesToOtherCities objectAtIndex:0] integerValue];
        chanceSum +=
            kWeightDown * [[city.distancesToOtherCities objectAtIndex:currentID] integerValue];
        
        chanceSum += (NSInteger)(1000.0 - (1000.0 * [[city.relevanceDict valueForKey:catA] floatValue]));
        chanceSum += (NSInteger)(1000.0 - (1000.0 * [[city.relevanceDict valueForKey:catB] floatValue]));
        chanceSum += 1000 - arc4random_uniform(1000);
        
        if (chanceSum < previousCitySum || previousCitySum < 0) {
            lastCity = city;
        }
        previousCitySum = chanceSum;
    }
    
    return lastCity;
}

/*
 * Returns array the size of kNumberOfCities with CityObj objects that have been filtered.
 * TODO: Currently filtering for n number of cities with largest population.
 */
- (NSArray *)cityArraySetup {
    NSArray *parsedArray = [self.dataParser getParsedArray];
    NSMutableArray *cityObjArray = [[NSMutableArray alloc] init];
    
    // Create a CityObj for every element in the parsed array, add into cityObjArray
    for (NSInteger i = 0; i < parsedArray.count; i++) {
        NSString *cityString = [[parsedArray objectAtIndex:i] objectAtIndex:0];
        NSString *stateString = [[parsedArray objectAtIndex:i] objectAtIndex:1];
        CityObj *currentCity = [self.apiObj preliminaryAttributeAssigner:cityString
                                                               withState:stateString
                                                         withParsedArray:parsedArray];
        [cityObjArray addObject:currentCity];
    }
    
    CityObj *startingCity = [self.apiObj preliminaryAttributeAssigner:self.startingCity
                                                            withState:self.startingState
                                                      withParsedArray:parsedArray];
    
    NSMutableArray *citiesWithinRange =
    [NSMutableArray arrayWithArray:[self.apiObj findCitiesInRange:[self.distanceRadiusAroundStartingCity integerValue]
                                                         nearCity:startingCity
                                                       fromCities:cityObjArray]];
    
    if (citiesWithinRange.count < self.cityCountToBeConsidered) {
        citiesWithinRange = [[self.apiObj findCitiesInRange:([self.distanceRadiusAroundStartingCity integerValue] * 2)
                                                   nearCity:startingCity
                                                 fromCities:cityObjArray] copy];
    }
    
    NSMutableArray *filteredCitiesWithinRange = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.cityCountToBeConsidered; i++) {
        [filteredCitiesWithinRange addObject:citiesWithinRange[i]];
    }
    
    NSArray *stepOneCityObjects = [NSArray arrayWithArray:[self.apiObj assignCityAttributes:filteredCitiesWithinRange]];
    NSArray *finalCityObjects = [NSArray arrayWithArray:[self assignCityIDsAndDistances:stepOneCityObjects]];
    
    return finalCityObjects;
}

/*
 * Returns array with updated CityObj objects with their identifier and respective distances to the other cities
 */
- (NSArray *)assignCityIDsAndDistances:(NSArray *)cities {
    NSMutableArray *citiesWithAssignments = [NSMutableArray array];
    CityObj *currentCity;
    NSLog(@"In assignCityIDsAndDistances:");
    NSLog(@"cities (parameter): %@", cities);
    NSLog(@"citiesWithAssignments initialized: %@", citiesWithAssignments);
    
    for (NSInteger i = 0; i < self.cityCountToBeConsidered; i++) {
        currentCity = cities[i];
        currentCity.identifier = @(i);
        currentCity.distancesToOtherCities = [self citiesMutualDistanceCalculator:currentCity cities:cities];
        
        [citiesWithAssignments addObject:currentCity];
    }
    
    return citiesWithAssignments;
}

/*
 * ALTERNATIVE SOLUTION -- CURRENT IMPLEMENTATION
 * Assign distance to every other city in new array, where the ith index represents distance to object with
 * ith identifier.
 */
- (NSArray *)citiesMutualDistanceCalculator:(CityObj *)currentCity cities:(NSArray *)cities {
    NSMutableArray *distances = [NSMutableArray array];
    NSInteger currentCityID = [currentCity.identifier integerValue];
    CityObj *cityToCompare;
    
    for (NSInteger i = 0; i < self.cityCountToBeConsidered; i++) {
        
        // For index representing same object, distance is zero
        if (i == currentCityID) {
            [distances addObject:[NSNumber numberWithInteger:0]];
            continue;
        }
        
        cityToCompare = cities[i];
        [distances addObject:[self.apiObj drivingDistanceBetweenCityObjects:currentCity cityB:cityToCompare]];
    }
    
    return distances;
}





@end
