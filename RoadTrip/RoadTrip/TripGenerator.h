//
//  TripGenerator.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Trip.h"

@class CustomizationOptions;

@interface TripGenerator : NSObject

- (instancetype)initWithOptions:(CustomizationOptions *)options NS_DESIGNATED_INITIALIZER;
- (NSArray *)generateNewTrips;

@end
