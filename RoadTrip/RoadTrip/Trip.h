//
//  Trip.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/9/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripOptions.h"

@interface Trip : NSObject <NSCoding>

@property (nonatomic, copy) NSDate *dateCreated;
@property (nonatomic, copy) NSString *startingLocation;
@property (nonatomic, copy) NSNumber *tripDuration;
@property (nonatomic, copy) NSNumber *farthestPointDistance;
@property (nonatomic, copy) NSArray *citiesVisited;

@property (nonatomic, copy) NSString *mapPath;

@property (nonatomic, copy) NSString *tripCategoryA;
@property (nonatomic, copy) NSString *tripCategoryB;

- (instancetype)initWithOptions:(TripOptions *)options NS_DESIGNATED_INITIALIZER;

@end
