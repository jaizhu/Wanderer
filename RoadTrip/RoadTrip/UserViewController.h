//
//  UserViewController.h
//  RoadTrip
//
//  Created by Sophia Raji on 7/9/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface UserViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *savedTrips;

- (void)addTripToSavedTrips:(Trip *)trip;

@end