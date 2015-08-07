//
//  NewsFeedController.h
//  RoadTrip
//
//  Created by Sophia Raji on 7/13/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface NewsFeedController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *_tableView;
@property (weak, nonatomic) Trip *trip;
@property (strong, nonatomic) NSMutableArray *places;
@property (strong, nonatomic) NSMutableArray *tripArray;
//@property (nonatomic, weak) IBOutlet id NewsFeedController delegate;
@end
