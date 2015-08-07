//
//  TripResultsViewControllerTests.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/13/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TripResultsStore.h"

@interface TripResultsViewControllerTests : XCTestCase

@property (nonatomic, strong) TripResultsStore *defaultRSToTest;

@end

@implementation TripResultsViewControllerTests

- (void)setUp {
    [super setUp];
    self.defaultRSToTest = [[TripResultsStore alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

/*
 * Testing default (dummy) initialization of TripResultsStore by
 * checking that an array with 5 Trip objects is returned.
 */
- (void)testTripResultsStore {
    XCTAssertEqual(5, self.defaultRSToTest.resultsList.count, @"Incorrect number of items in ResultsStore");
}



@end
