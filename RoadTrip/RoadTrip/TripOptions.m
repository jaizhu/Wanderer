//
//  TripOptions.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/9/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "TripOptions.h"

@implementation TripOptions

+ (instancetype)genericOptions {
    TripOptions *genericOptions = [[TripOptions alloc] init];
    
    genericOptions.dateCreated = [NSDate date];
    genericOptions.startingLocation = @"Starting city";
    genericOptions.tripDuration = @1;
    genericOptions.farthestPointDistance = @120;
    genericOptions.citiesVisited = @[@"City 1", @"City 2"];
    
    return genericOptions;
}

@end
