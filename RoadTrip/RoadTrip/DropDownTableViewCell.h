//
//  DropDownTableViewCell.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/28/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *categories;
@property (weak, nonatomic) IBOutlet UIButton *openURL;
@property (copy, nonatomic) NSString *actualYelpURL;

- (void)setupDropdownCellUI;

@end
