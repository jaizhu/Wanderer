//
//  TripSaver.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/23/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trip.h"

@interface TripSaver : NSObject

@property (strong, nonatomic) NSMutableArray *savedTrips;

- (void)saveTrip:(Trip *)trip;
- (NSArray *)getTrips;
- (BOOL)saveChanges;
- (void)deleteTrip:(Trip *)deletedTrip;

@end
