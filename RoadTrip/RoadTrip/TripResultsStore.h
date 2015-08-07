//
//  TripResultStore.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/9/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"
#import "CustomizationOptions.h"

@interface TripResultsStore : NSObject

// TODO: Will be designated initializer when finished
- (instancetype)initWithOptions:(CustomizationOptions *)options;

- (NSArray *)resultsList;
- (Trip *)lastTrip;

@end
