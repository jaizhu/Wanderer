//
//  ResultCell.m
//  RoadTrip
//
//  Created by Sophia Raji on 7/7/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "ResultCell.h"
#import "Trip.h"
#import "CityObj.h"

@implementation ResultCell

- (void)setupCellUI {
    // Customizing cell selection
    UIView *backgroundSelectedCell = [[UIView alloc] init];
    [backgroundSelectedCell setBackgroundColor:[UIColor colorWithRed:20.0 green:20.0 blue:20.0 alpha:0.5]];
    self.selectedBackgroundView = backgroundSelectedCell;
}

- (void)setupResultCell:(Trip *)thisTrip {
    NSString *tripName =
    [NSString stringWithFormat:@"%@, %@ +%lu more",[[thisTrip.citiesVisited firstObject] cityName], [[thisTrip.citiesVisited objectAtIndex:1] cityName], ([thisTrip.citiesVisited count] - 2)];
    self.tripNameLabel.text = tripName;
    
    self.tripDrivingAmt.text = [NSString stringWithFormat:@"Drive up to %ld miles per day", (long)([thisTrip.farthestPointDistance floatValue] / 1.6)];
    
    self.tripCategoriesLabel.text = [NSString stringWithFormat:@"%@ & %@", thisTrip.tripCategoryA, thisTrip.tripCategoryB];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

@end
