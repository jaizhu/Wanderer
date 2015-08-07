//
//  CustomizationOptions.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "CustomizationOptions.h"

@implementation CustomizationOptions

+ (instancetype)genericOptions {
    CustomizationOptions *genericOptions = [[CustomizationOptions alloc] init];
    
    genericOptions.startingCity = @[@"Austin", @"TX"];
    genericOptions.tripDuration = @3;
    genericOptions.farthestDistanceInHours = @6;
    
    return genericOptions;
}

@end
