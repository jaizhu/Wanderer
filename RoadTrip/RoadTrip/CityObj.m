//
//  CityObj.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "CityObj.h"

@interface CityObj ()
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
@end

@implementation CityObj

- (instancetype)initWithName:(NSString *)name andState:(NSString *)state {
    self = [super init];
    if (self) {
        self.cityName = name;
        self.cityState = state;
        NSArray *keys = [[NSArray alloc] initWithObjects:@"Parks", @"Performing Arts", @"Museums", @"Best Restaurants", @"Nightlife", nil];
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        for (int i = 0; i < [keys count]; ++i) {
            [objects addObject:@999];
        }
        self.relevanceDict = [[NSMutableDictionary alloc] initWithObjects:objects
                                                                  forKeys:keys];
        self.placesDict = [[NSMutableDictionary alloc] initWithObjects:objects
                                                               forKeys:keys];
    }
    return self;
}

- (NSString *)description {
    NSString *fullName = [[NSString alloc] initWithFormat:@"%@, %@", self.cityName, self.cityState];
    
    return fullName;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _cityName = [aDecoder decodeObjectForKey:@"cityName"];
        _cityState = [aDecoder decodeObjectForKey:@"cityState"];
        _population = [aDecoder decodeObjectForKey:@"population"];
        _location.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        _location.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        _identifier = [aDecoder decodeObjectForKey:@"identifier"];
        _distancesToOtherCities = [aDecoder decodeObjectForKey:@"distanceToOtherCities"];
        _alreadyVisited = [aDecoder decodeBoolForKey:@"alreadyVisited"];
        _relevanceDict = [aDecoder decodeObjectForKey:@"relevanceDict"];
        _placesDict = [aDecoder decodeObjectForKey:@"placesDict"];
    }
    return self;
}

// MARK: Encoding and decoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.cityState forKey:@"cityState"];
    [aCoder encodeObject:self.population forKey:@"population"];
    [aCoder encodeDouble:self.location.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.location.longitude forKey:@"longitude"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeObject:self.distancesToOtherCities forKey:@"distanceToOtherCities"];
    [aCoder encodeBool:self.alreadyVisited forKey:@"alreadyVisited"];
    [aCoder encodeObject:self.relevanceDict forKey:@"relevanceDict"];
    [aCoder encodeObject:self.placesDict forKey:@"placesDict"];
}

@end


