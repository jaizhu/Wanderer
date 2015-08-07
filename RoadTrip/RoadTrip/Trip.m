//
//  Trip.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/9/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "Trip.h"

@interface Trip ()
@property (nonatomic, strong) Trip *dummyTrip;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
@end

@implementation Trip

// MARK: Trip lifecycle
- (instancetype)initWithOptions:(TripOptions *)options {
    self = [super init];
    if (self) {
        self.dateCreated = options.dateCreated;
        self.startingLocation = options.startingLocation;
        self.tripDuration = options.tripDuration;
        self.farthestPointDistance = options.farthestPointDistance;
        self.citiesVisited = options.citiesVisited;
        self.mapPath = options.mapPath;
        self.tripCategoryA = options.tripCategoryA;
        self.tripCategoryB = options.tripCategoryB;
    }
    return self;
}

- (instancetype)init {
    TripOptions *genericOptions = [TripOptions genericOptions];
    return [self initWithOptions:genericOptions];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _startingLocation = [aDecoder decodeObjectForKey:@"startingLocation"];
        _tripDuration= [aDecoder decodeObjectForKey:@"tripDuration"];
        _farthestPointDistance = [aDecoder decodeObjectForKey:@"farthestPointDistance"];
        _citiesVisited = [aDecoder decodeObjectForKey:@"citiesVisited"];
        _mapPath = [aDecoder decodeObjectForKey:@"mapPath"];
        _tripCategoryA = [aDecoder decodeObjectForKey:@"tripCategoryA"];
        _tripCategoryB = [aDecoder decodeObjectForKey:@"tripCategoryB"];
    }
    return self;
}

// MARK: Encoding and decoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.startingLocation forKey:@"startingLocation"];
    [aCoder encodeObject:self.tripDuration forKey:@"tripDuration"];
    [aCoder encodeObject:self.farthestPointDistance forKey:@"farthestPointDistance"];
    [aCoder encodeObject:self.citiesVisited forKey:@"citiesVisited"];
    [aCoder encodeObject:self.mapPath forKey:@"mapPath"];
    [aCoder encodeObject:self.tripCategoryA forKey:@"tripCategoryA"];
    [aCoder encodeObject:self.tripCategoryB forKey:@"tripCategoryB"];
}

// MARK: Helper methods
- (NSString *)description {
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"Start Loc: %@, Duration: %@, Farthest Dist: %@, Cities: %@",
     self.startingLocation,
     self.tripDuration,
     self.farthestPointDistance,
     self.citiesVisited];
    
    return descriptionString;
}

- (TripOptions *)dummyOptions {
    TripOptions *options = [[TripOptions alloc] init];
    options.dateCreated = [NSDate date];
    options.startingLocation = @"Starting city";
    options.tripDuration = @1;
    options.farthestPointDistance = @120;
    options.citiesVisited = @[@"City 1", @"City 2"];
    
    return options;
}

@end
