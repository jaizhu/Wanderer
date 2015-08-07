//
//  TripSaver.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/23/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripSaver.h"

@implementation TripSaver

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.savedTrips = [[NSMutableArray alloc] initWithArray:[self getTrips]];
    }
    
    return self;
}

/*
 * This method needs to open the file path, add an object to the array of trips then close the file path
 */
- (void)saveTrip:(Trip *)trip {
    self.savedTrips = [[NSMutableArray alloc] initWithArray:[self getTrips]];
    [self.savedTrips addObject:trip];
    
    BOOL success = [self saveChanges];
    if (success) {
        NSLog(@"Saved trip successfully");
    } else {
        NSLog(@"Could not save trip");
    }
}

- (BOOL)saveChanges {
    NSLog(@"Saving new trip array to %@", [self tripsArchivePath]);
    BOOL success = [NSKeyedArchiver archiveRootObject:self.savedTrips
                                               toFile:[self tripsArchivePath]];
    // Update the MyTrips table view with new trips
    
    return success;
}

/*
 * This method needs to fetch the trips stored within the file path
 */
- (NSArray *)getTrips {
    NSString *archivePath = [self tripsArchivePath];
    NSArray *archivedTrips = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    return archivedTrips;
}

/*
 * This method needs to delete the trip selected
 */
- (void)deleteTrip:(Trip *)deletedTrip {
    self.savedTrips = [[NSMutableArray alloc] initWithArray:[self getTrips]];
    [self.savedTrips removeObject:deletedTrip];
    BOOL success = [self saveChanges];
    if (success) {
        NSLog(@"Saved edited successfully");
    } else {
        NSLog(@"Could not edit trip");
    }
}

// MARK: Creates path for trips to be archived
- (NSString *)tripsArchivePath {
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask,
                                                                        YES);
    NSString *documentDirectory = [documentsDirectories firstObject];
    NSString *documentPath =
    [documentDirectory stringByAppendingPathComponent:@"trips.archive"];
    return documentPath;
}

@end
