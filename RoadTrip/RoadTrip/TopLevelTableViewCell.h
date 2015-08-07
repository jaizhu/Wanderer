//
//  TopLevelTableViewCell.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/28/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownTableViewCell.h"

@interface TopLevelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityName;

@property (strong, nonatomic) DropDownTableViewCell *dropDownCell1;
@property (strong, nonatomic) DropDownTableViewCell *dropDownCell2;
@property (strong, nonatomic) DropDownTableViewCell *dropDownCell3;
@property (strong, nonatomic) DropDownTableViewCell *dropDownCell4;
@property (strong, nonatomic) DropDownTableViewCell *dropDownCell5;

@property (weak, nonatomic) UIImageView *arrow;

- (void)setupTopLevelCell:(NSString *)cityName;
- (void)setupDropdownCell:(DropDownTableViewCell *)dropdownCell
      indexOfDropdownCell:(NSInteger) index;

@end
