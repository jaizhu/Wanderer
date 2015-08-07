//
//  TopLevelTableViewCell.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/28/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopLevelTableViewCell.h"
#import "DropDownTableViewCell.h"
#import "CityObj.h"

@implementation TopLevelTableViewCell

// MARK: Cell setup

- (void)setupTopLevelCell:(CityObj *)city {
    self.cityName.text = city.description;
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
    self.accessoryView = arrow;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setupDropdownCell:(DropDownTableViewCell *)dropdownCell
      indexOfDropdownCell:(NSInteger) index {
    
    if (index == 0) {
        self.dropDownCell1 = dropdownCell;
    } else if (index == 1) {
        self.dropDownCell2 = dropdownCell;
    } else if (index == 2) {
        self.dropDownCell3 = dropdownCell;
    } else if (index == 3) {
        self.dropDownCell4 = dropdownCell;
    } else if (index == 4) {
        self.dropDownCell5 = dropdownCell;
    }
}

@end
