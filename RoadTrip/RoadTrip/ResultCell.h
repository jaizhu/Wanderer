//
//  ResultCell.h
//  RoadTrip
//
//  Created by Sophia Raji on 7/7/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface ResultCell : UITableViewCell

// Home page
@property (weak, nonatomic) IBOutlet UILabel *tripNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripDrivingAmt;
@property (weak, nonatomic) IBOutlet UILabel *tripCategoriesLabel;

// Results page
@property (weak, nonatomic) IBOutlet UILabel *RTripNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *RTripDrivingAmt;
@property (weak, nonatomic) IBOutlet UILabel *RTripCategoriesLabel;

- (void)setupCellUI;
- (void)setupResultCell:(Trip *)thisTrip;

@end
