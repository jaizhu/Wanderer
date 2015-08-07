//
//  MyTripsViewController.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 8/3/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripSaver.h"

@interface MyTripsViewController : UIViewController <UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *cells;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *stateName;

@end
