//
//  ResultsViewController.h
//  RoadTrip
//
//  Created by Sophia Raji on 7/6/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TripResultsStore;

@interface TripResultsViewController : UIViewController <UITableViewDelegate>

@property (copy, nonatomic) NSString *stateName;

- (instancetype)initWithTripResultsStore:(TripResultsStore *)store;

@end
