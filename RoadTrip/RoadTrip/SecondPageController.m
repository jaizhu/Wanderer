//
//  SecondPageController.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondPageController.h"

const NSInteger kLowestDaysAllowed = 3;

@interface SecondPageController ()

@property (nonatomic, strong) NSNumber *daySelected;

@end

@implementation SecondPageController

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tempDays = [[NSMutableArray alloc] init];
    for (int i = kLowestDaysAllowed; i <= 30; ++i) {
        NSString *stringFromInt = [NSString stringWithFormat:@"%d", i];
        [tempDays addObject:stringFromInt];
    }
    self.daysArray = [[NSArray alloc] initWithArray:tempDays];
    self.daySelected = self.daysArray[0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate addDaysOfTrip:self didFinishEnteringItem:self.daySelected];
}

// MARK: UIPickerView delegate and data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.daysArray.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
    NSAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.daysArray[row]
                                           attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.daySelected = @(row + kLowestDaysAllowed);
}

@end
