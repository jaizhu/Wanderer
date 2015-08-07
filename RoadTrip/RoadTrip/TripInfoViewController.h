//
//  TripInfoViewController.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/6/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Trip.h"

@interface TripInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Trip *currentTrip;
@property (copy, nonatomic) NSString *yelpURL;

@end
