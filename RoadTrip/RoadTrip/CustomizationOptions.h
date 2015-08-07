//
//  CustomizationOptions.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomizationOptions : NSObject

// Starting city array has city in first index and 2-letter state in second
@property (nonatomic, copy) NSArray *startingCity;
@property (nonatomic, copy) NSNumber *tripDuration;
@property (nonatomic, copy) NSNumber *farthestDistanceInHours;

+ (instancetype)genericOptions;

@end
